class CreateTaxMaps < ActiveRecord::Migration
  def self.up
    create_table :tax_maps do |t|
      t.string :tax_map_number, :null => false
      t.string :city
      t.string :zip_code
      t.string :state_abbr
    end

    add_index :tax_maps, [:tax_map_number], :unique => true    
  end

  def self.down
    remove_index :tax_maps, [:tax_map_number]
    drop_table :tax_maps
  end
end
