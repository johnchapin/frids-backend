require 'active_record/fixtures'

class LoadTaxMapData < ActiveRecord::Migration
  def self.up
    down
    directory = File.join(File.dirname(__FILE__), 'data') 
    Fixtures.create_fixtures(directory, "tax_maps")
  end

  def self.down
    execute "DELETE FROM tax_maps"
  end
end
