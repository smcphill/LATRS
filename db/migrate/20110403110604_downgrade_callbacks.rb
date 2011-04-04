class DowngradeCallbacks < ActiveRecord::Migration
  def self.up
    remove_column :callbacks, :id
    remove_column :callbacks, :created_at
    remove_column :callbacks, :updated_at
  end
end
