require 'pp'

class Event < ActiveRecord::Base
  before_create   :process_location

  has_many :lines
  belongs_to :location

  private
    def process_location
      @key = LocationsHelper.createKey(self.address, self.tax_map)
      @location = Location.find_by_key(@key)
      self.tax_map ||= "000"
      self.tax_map.gsub!(/[^\d].*/,"")
      if (@location.nil?)
        @tax_map = TaxMap.find_by_tax_map_number(self.tax_map)
        @location = Location.create(:key => @key, :tax_map => @tax_map, :dirty_address => self.address)
        Delayed::Job.enqueue @location
      end
      self.location_id = @location.id
    end
end
