class CreateTestOutcomes < ActiveRecord::Migration
  def self.up
    create_table :test_outcomes do |t|
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :test_outcomes
  end
end
