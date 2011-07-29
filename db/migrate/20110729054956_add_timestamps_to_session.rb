class AddTimestampsToSession < ActiveRecord::Migration
  def self.up
    add_column :sessions, :created_at, :timestamp
    add_column :sessions, :updated_at, :timestamp
  end

  def self.down
    remove_column :sessions, :updated_at
    remove_column :sessions, :created_at
  end
end
