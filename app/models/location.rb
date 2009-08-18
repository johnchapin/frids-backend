class Location < ActiveRecord::Base
  has_many :events
  belongs_to :tax_map
end
