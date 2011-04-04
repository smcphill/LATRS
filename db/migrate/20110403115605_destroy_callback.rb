class DestroyCallback < ActiveRecord::Migration
  def self.up
    drop_table :callbacks
  end

  def self.down
  end
end
