class AddCallReceivedIndexToLines < ActiveRecord::Migration
  def self.up
    add_index :lines, [:call_received]
  end

  def self.down
    remove_index :lines, [:call_received]
  end
end
