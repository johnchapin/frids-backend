class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime    :event_datetime, :null => false
      t.string  :address, :null => false
      t.string  :tax_map
      t.integer :location_id
      t.timestamps
    end

    add_index :events, [:event_datetime, :address], :unique => true
  end

  def self.down
    remove_index :events, [:event_datetime, :address]
    drop_table :events
  end
end
