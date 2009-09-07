require 'active_record/fixtures'

class LoadLocationData < ActiveRecord::Migration
  def self.up
    down
    directory = File.join(File.dirname(__FILE__), 'data') 
    Fixtures.create_fixtures(directory, "locations")
  end

  def self.down
    execute "DELETE FROM locations"
  end
end
