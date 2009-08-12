class Event < ActiveRecord::Base
  before_create   :process_location

  has_many :lines
  belongs_to :location

  private
    def process_location
      @key = LocationsHelper.createKey(self.address)
      @location = Location.find_by_key(@key)
      if (@location.nil?)
        @location = Location.create(:key => @key, :tax_map => self.tax_map)
      end
      self.location_id = @location.id
    end
end
