class AddFKsToTestOutcome < ActiveRecord::Migration
  def self.up
    add_column :test_outcomes, :test_id, :decimal
    add_column :test_outcomes, :outcome_type_id, :decimal
  end

  def self.down
    remove_column :test_outcomes, :outcome_type_id
    remove_column :test_outcomes, :test_id
  end
end
