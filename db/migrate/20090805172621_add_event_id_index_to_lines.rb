class AddEventIdIndexToLines < ActiveRecord::Migration
  def self.up
    add_index :lines, [:event_id]
  end

  def self.down
    remove_index :lines, [:event_id]
  end
end
