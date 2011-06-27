class CreateTestableitems < ActiveRecord::Migration
  def self.up
    create_table :testableitems do |t|
      t.integer :testable_id
      t.integer :field_id
      t.string :value_s
      t.integer :value_i

      t.timestamps
    end
  end

  def self.down
    drop_table :testableitems
  end
end
