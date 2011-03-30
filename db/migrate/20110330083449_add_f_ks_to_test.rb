class AddFKsToTest < ActiveRecord::Migration
  def self.up
    add_column :tests, :tester_id, :decimal
    add_column :tests, :patient_id, :decimal
    add_column :tests, :source_id, :decimal
    add_column :tests, :test_type_id, :decimal
    add_column :tests, :parent_id, :decimal
  end

  def self.down
    remove_column :tests, :parent_id
    remove_column :tests, :test_type_id
    remove_column :tests, :source_id
    remove_column :tests, :patient_id
    remove_column :tests, :tester_id
  end
end
