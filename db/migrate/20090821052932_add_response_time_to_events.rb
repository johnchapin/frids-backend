class AddResponseTimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :response_time, :integer
  end

  def self.down
    remove_column :events, :response_time
  end
end
