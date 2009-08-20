#!/usr/bin/env ruby

require 'rubygems'
require 'ym4r/google_maps/geocoding'
require 'active_record'
require 'yaml'
require 'frids-backend-webapp/app/models/location.rb'
require 'frids-backend-webapp/app/models/tax_map.rb'
require 'frids-backend-webapp/app/helpers/locations_helper.rb'
require 'pp'

include Ym4r::GoogleMaps

dbconfig = YAML::load(File.open('frids-backend-webapp/config/database.yml'))  
ActiveRecord::Base.establish_connection(dbconfig['development'])

@locations = Location.find(:all, :conditions => { :status => nil },
                                 :include => :tax_map )
@locations.each do | location |

  location.clean_address =LocationsHelper.cleanAddress(location.dirty_address) +
    (location.tax_map.city ? ", #{location.tax_map.city}" : "") +
    (location.tax_map.state_abbr ? ", #{location.tax_map.state_abbr}" : "") +
    (location.tax_map.zip_code ? " #{location.tax_map.zip_code}" : "")

  location.status = ""
  results = Geocoding::get(location.clean_address)
  if results.status == Geocoding::GEO_SUCCESS
    location.latitude,location.longitude = results[0].latlon
    location.status = "INVALID"
    if location.tax_map.tax_map_number == "000"
      if (location.latitude != 38.037764 && location.longitude != -78.48926) &&
          location.latitude.between?(location.tax_map.min_lat, location.tax_map.max_lat) &&
          location.longitude.between?(location.tax_map.min_lon, location.tax_map.max_lon)
        location.status = "APPROXIMATE"
      end
    else
      if location.latitude.between?(location.tax_map.min_lat,
                                    location.tax_map.max_lat) &&
         location.longitude.between?(location.tax_map.min_lon,
                                     location.tax_map.max_lon)
        location.status = "VALID"
      else
        location.latitude = location.tax_map.center_lat
        location.longitude = location.tax_map.center_lon
        location.status = "APPROXIMATE"
        if location.latitude == 38.037764 && location.longitude == -78.48926
          location.status = "INVALID"
        end
      end
    end
  else
    location.status = "FAILED"
  end

  location.save
  sleep(0.25)

end
