class Location < ActiveRecord::Base

  CHARLOTTESVILLE_LATLON = [38.037764,-78.48926]

  has_many :events
  belongs_to :tax_map

  def is_center?
    
  end

  # For Delayed Job, this will allow asynchronous geo-coding
  def perform
    geocode
    sleep 0.2
  end

  private

  def geocode
    self.clean_address =
      LocationsHelper.cleanAddress(self.dirty_address) +
      (self.tax_map.city ? ", #{self.tax_map.city}" : "") +
      (self.tax_map.state_abbr ? ", #{self.tax_map.state_abbr}" : "") +
      (self.tax_map.zip_code ? " #{self.tax_map.zip_code}" : "")
    self.status = ""
    logger.info "Attempting to geocode: #{self.clean_address}"
    results = Geocoding::get(self.clean_address, :key => "ABQIAAAAzMUFFnT9uH0xq39J0Y4kbhTJQa0g3IQ9GZqIMmInSLzwtGDKaBR6j135zrztfTGVOm2QlWnkaidDIQ" )
    if results.status == Geocoding::GEO_SUCCESS
      self.latitude,self.longitude = results[0].latlon
      self.status = "INVALID"
      if self.tax_map.tax_map_number == "000"
        if !([self.latitude,self.longitude] == CHARLOTTESVILLE_LATLON) &&
          self.latitude.between?(self.tax_map.min_lat,
                                     self.tax_map.max_lat) &&
          self.longitude.between?(self.tax_map.min_lon,
                                      self.tax_map.max_lon)
          self.status = "APPROXIMATE"
        end
      else
        if self.latitude.between?(self.tax_map.min_lat,
                                      self.tax_map.max_lat) &&
           self.longitude.between?(self.tax_map.min_lon,
                                       self.tax_map.max_lon)
          self.status = "VALID"
        else
          self.latitude = self.tax_map.center_lat
          self.longitude = self.tax_map.center_lon
          self.status = "APPROXIMATE"
          if [self.latitude,self.longitude] == CHARLOTTESVILLE_LATLON
            self.status = "INVALID"
          end
        end
      end
    else
      self.status = "FAILED"
    end
    self.save
  end

end
