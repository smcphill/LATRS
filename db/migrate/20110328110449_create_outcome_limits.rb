class CreateOutcomeLimits < ActiveRecord::Migration
  def self.up
    create_table :outcome_limits do |t|
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :outcome_limits
  end
end
