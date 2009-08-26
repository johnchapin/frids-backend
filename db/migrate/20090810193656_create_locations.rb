class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string    :key, :null => false
      t.string    :status
      t.string    :dirty_address
      t.string    :clean_address
      t.string    :city
      t.string    :state
      t.string    :zip_code
      t.string    :tax_map_val
      t.decimal   :latitude, :precision => 10, :scale => 7
      t.decimal   :longitude, :precision => 10, :scale => 7
      t.timestamps
    end

    add_index :locations, :key, :unique => true
    add_index :locations, :dirty_address
    add_index :locations, :clean_address
    add_index :locations, :latitude
    add_index :locations, :longitude
  end

  def self.down
    remove_index :locations, :key
    remove_index :locations, :dirty_address
    remove_index :locations, :clean_address
    remove_index :locations, :latitude
    remove_index :locations, :longitude
    drop_table :locations
  end
end
