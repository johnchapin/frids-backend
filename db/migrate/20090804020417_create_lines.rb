class CreateLines < ActiveRecord::Migration
  def self.up
    create_table :lines do |t|
      t.string    :line_type,        :null => false
      t.date      :line_date,        :null => false
      t.integer   :incident_number,  :null => false
      t.string    :unit,             :null => false
      t.string    :location,         :null => false
      t.string    :tax_map
      t.string    :call_type,        :null => false
      t.time      :call_received,    :null => false
      t.time      :call_dispatch
      t.time      :unit_enroute
      t.time      :staged_near_scene
      t.time      :arrived_on_scene
      t.time      :left_scene
      t.time      :arrived_hosp
      t.time      :in_service
      t.string    :url
      t.integer   :event_id
      t.timestamps
    end

    add_index :lines, [:line_date, :incident_number, :unit], :unique => true
  end

  def self.down
    remove_index :lines, [:line_date, :incident_number, :unit]
    drop_table :lines
  end
end
