class AddFKsToOutcomeType < ActiveRecord::Migration
  def self.up
    add_column :outcome_types, :parent_id, :decimal
    add_column :outcome_types, :test_type_id, :decimal
  end

  def self.down
    remove_column :outcome_types, :test_type_id
    remove_column :outcome_types, :parent_id
  end
end
