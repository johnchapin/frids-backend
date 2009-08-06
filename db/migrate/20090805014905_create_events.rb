class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date    :event_date, :null => false
      t.time    :event_time, :null => false
      t.string  :location, :null => false
      t.string  :tax_map
      t.decimal :latitude
      t.decimal :longitude
    end

    add_index :events, [:event_date, :event_time, :location], :unique => true
  end

  def self.down
    remove_index :events, [:event_date, :event_time, :location]
    drop_table :events
  end
end
