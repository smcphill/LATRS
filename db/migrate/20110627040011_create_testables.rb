class CreateTestables < ActiveRecord::Migration
  def self.up
    create_table :testables do |t|
      t.integer :linked_test_id
      t.integer :patient_id
      t.integer :staff_id
      t.integer :source_id
      t.integer :department_id
      t.string :type
      t.timestamp :time_in
      t.timestamp :time_out

      t.timestamps
    end
  end

  def self.down
    drop_table :testables
  end
end
