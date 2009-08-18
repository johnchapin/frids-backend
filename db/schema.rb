# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090813032304) do

  create_table "events", :force => true do |t|
    t.datetime "event_datetime", :null => false
    t.string   "address",        :null => false
    t.string   "tax_map"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_datetime", "address"], :name => "index_events_on_event_datetime_and_address", :unique => true

  create_table "lines", :force => true do |t|
    t.string   "line_type",         :null => false
    t.date     "line_date",         :null => false
    t.integer  "incident_number",   :null => false
    t.string   "unit",              :null => false
    t.string   "address",           :null => false
    t.string   "tax_map"
    t.string   "call_type",         :null => false
    t.datetime "call_received",     :null => false
    t.datetime "call_dispatch"
    t.datetime "unit_enroute"
    t.datetime "staged_near_scene"
    t.datetime "arrived_on_scene"
    t.datetime "left_scene"
    t.datetime "arrived_hosp"
    t.datetime "in_service"
    t.string   "url"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lines", ["event_id"], :name => "index_lines_on_event_id"
  add_index "lines", ["line_date", "incident_number", "unit"], :name => "index_lines_on_line_date_and_incident_number_and_unit", :unique => true

  create_table "locations", :force => true do |t|
    t.string   "key",                                          :null => false
    t.string   "status"
    t.string   "dirty_address"
    t.string   "clean_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "tax_map_id"
    t.decimal  "latitude",      :precision => 10, :scale => 7
    t.decimal  "longitude",     :precision => 10, :scale => 7
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["clean_address"], :name => "index_locations_on_clean_address"
  add_index "locations", ["dirty_address"], :name => "index_locations_on_dirty_address"
  add_index "locations", ["key"], :name => "index_locations_on_key", :unique => true
  add_index "locations", ["latitude"], :name => "index_locations_on_latitude"
  add_index "locations", ["longitude"], :name => "index_locations_on_longitude"

  create_table "tax_maps", :force => true do |t|
    t.string   "tax_map_number",                                :null => false
    t.string   "city"
    t.string   "zip_code"
    t.string   "state_abbr"
    t.decimal  "nw_lat",         :precision => 7, :scale => 10
    t.decimal  "nw_lon",         :precision => 7, :scale => 10
    t.decimal  "ne_lat",         :precision => 7, :scale => 10
    t.decimal  "ne_lon",         :precision => 7, :scale => 10
    t.decimal  "se_lat",         :precision => 7, :scale => 10
    t.decimal  "se_lon",         :precision => 7, :scale => 10
    t.decimal  "sw_lat",         :precision => 7, :scale => 10
    t.decimal  "sw_lon",         :precision => 7, :scale => 10
    t.decimal  "center_lat",     :precision => 7, :scale => 10
    t.decimal  "center_lon",     :precision => 7, :scale => 10
    t.decimal  "min_lat",        :precision => 7, :scale => 10
    t.decimal  "max_lat",        :precision => 7, :scale => 10
    t.decimal  "min_lon",        :precision => 7, :scale => 10
    t.decimal  "max_lon",        :precision => 7, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tax_maps", ["tax_map_number"], :name => "index_tax_maps_on_tax_map_number", :unique => true

end
