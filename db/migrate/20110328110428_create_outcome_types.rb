class CreateOutcomeTypes < ActiveRecord::Migration
  def self.up
    create_table :outcome_types do |t|
      t.string :name
      t.boolean :is_required
      t.boolean :is_general
      t.boolean :is_limited

      t.timestamps
    end
  end

  def self.down
    drop_table :outcome_types
  end
end
