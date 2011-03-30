class AddFKsToTestType < ActiveRecord::Migration
  def self.up
    add_column :test_types, :parent_id, :decimal
  end

  def self.down
    remove_column :test_types, :parent_id
  end
end
