class CreateTaxMaps < ActiveRecord::Migration
  def self.up
    create_table :tax_maps do |t|
      t.string :tax_map_number, :null => false
      t.string :city
      t.string :zip_code
      t.string :state_abbr
      t.decimal :nw_lat, :scale => 10, :precision => 7
      t.decimal :nw_lon, :scale => 10, :precision => 7
      t.decimal :ne_lat, :scale => 10, :precision => 7
      t.decimal :ne_lon, :scale => 10, :precision => 7
      t.decimal :se_lat, :scale => 10, :precision => 7
      t.decimal :se_lon, :scale => 10, :precision => 7
      t.decimal :sw_lat, :scale => 10, :precision => 7
      t.decimal :sw_lon, :scale => 10, :precision => 7
      t.decimal :center_lat, :scale => 10, :precision => 7
      t.decimal :center_lon, :scale => 10, :precision => 7
      t.decimal :min_lat, :scale => 10, :precision => 7
      t.decimal :max_lat, :scale => 10, :precision => 7
      t.decimal :min_lon, :scale => 10, :precision => 7
      t.decimal :max_lon, :scale => 10, :precision => 7
      t.timestamps
    end

    add_index :tax_maps, [:tax_map_number], :unique => true    
  end

  def self.down
    remove_index :tax_maps, [:tax_map_number]
    drop_table :tax_maps
  end
end
