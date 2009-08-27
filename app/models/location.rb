class Location < ActiveRecord::Base

  CHARLOTTESVILLE_LATLON = [38.037764,-78.48926]
  THROTTLE_THRESHOLD = 256
  INITIAL_DELAY = 2
  DELAY_STEP = 2

  has_many :events
  belongs_to :tax_map, :foreign_key => :tax_map_val

  # For Delayed Job, this will allow asynchronous geo-coding
  def perform
    geocode
  end

  private

  def centered_on_cville?
    [self.latitude,self.longitude] == CHARLOTTESVILLE_LATLON
  end

  def within_tax_map?
    self.latitude.between?(self.tax_map.min_lat,self.tax_map.max_lat) && self.longitude.between?(self.tax_map.min_lon,self.tax_map.max_lon)
  end

  def geocode

    if self.tax_map.nil?
      self.tax_map = TaxMap.find_by_tax_map_number("000")
    end

    self.clean_address =
      LocationsHelper.cleanAddress(self.dirty_address) +
      (self.tax_map.city ? ", #{self.tax_map.city}" : "") +
      (self.tax_map.state_abbr ? ", #{self.tax_map.state_abbr}" : "") +
      (self.tax_map.zip_code ? " #{self.tax_map.zip_code}" : "")
    self.status = ""
    pending = true
    logger.info "Attempting to geocode: #{self.clean_address}"
    delay = INITIAL_DELAY
    while (pending)
      results = Geocoding::get(self.clean_address, :key => "ABQIAAAAzMUFFnT9uH0xq39J0Y4kbhTJQa0g3IQ9GZqIMmInSLzwtGDKaBR6j135zrztfTGVOm2QlWnkaidDIQ" )
      # results = Geocoding::get(self.clean_address)
      if results.status == Geocoding::GEO_SUCCESS
        pending = false
        self.latitude,self.longitude = results[0].latlon
        logger.info "Successfully geocoded #{self.clean_address} to [#{self.latitude},#{self.longitude}]"
        self.status = "INVALID"
        if self.tax_map.tax_map_number == "000"
          if !centered_on_cville? && within_tax_map?
            self.status = "APPROXIMATE"
          end
        else
          if within_tax_map?
            self.status = "VALID"
          else
            self.latitude = self.tax_map.center_lat
            self.longitude = self.tax_map.center_lon
            self.status = "APPROXIMATE"
            if centered_on_cville?
              self.status = "INVALID"
            end
          end
        end
      elsif results.status == Geocoding::GEO_TOO_MANY_QUERIES
        delay *= delay
        if (delay > THROTTLE_THRESHOLD) 
          pending = false
          logger.error "Geocoding throttled past #{THROTTLE_THRESHOLD} seconds"
          self.status = "FAILED: #{results.status}"
        else
          logger.warn "Throttling geocode rate, delay = #{delay}"
        end
      else
        self.status = "FAILED: #{results.status}"
        pending = false
        logger.error "Geocoding failed miserably, delay = #{delay}, status code = #{results.status}"
      end
      sleep delay
    end
    self.save
  end

end
