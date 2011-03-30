class AddFKsToOutcomeLimit < ActiveRecord::Migration
  def self.up
    add_column :outcome_limits, :outcome_type_id, :decimal
  end

  def self.down
    remove_column :outcome_limits, :outcome_type_id
  end
end
