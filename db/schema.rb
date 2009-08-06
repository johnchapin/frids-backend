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

ActiveRecord::Schema.define(:version => 20090805172621) do

  create_table "events", :force => true do |t|
    t.date    "event_date", :null => false
    t.time    "event_time", :null => false
    t.string  "location",   :null => false
    t.string  "tax_map"
    t.decimal "latitude"
    t.decimal "longitude"
  end

  add_index "events", ["event_date", "event_time", "location"], :name => "index_events_on_event_date_and_event_time_and_location", :unique => true

  create_table "lines", :force => true do |t|
    t.string   "line_type",         :null => false
    t.date     "line_date",         :null => false
    t.integer  "incident_number",   :null => false
    t.string   "unit",              :null => false
    t.string   "location",          :null => false
    t.string   "tax_map"
    t.string   "call_type",         :null => false
    t.time     "call_received",     :null => false
    t.time     "call_dispatch"
    t.time     "unit_enroute"
    t.time     "staged_near_scene"
    t.time     "arrived_on_scene"
    t.time     "left_scene"
    t.time     "arrived_hosp"
    t.time     "in_service"
    t.string   "url"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lines", ["event_id"], :name => "index_lines_on_event_id"
  add_index "lines", ["line_date", "incident_number", "unit"], :name => "index_lines_on_line_date_and_incident_number_and_unit", :unique => true

end
