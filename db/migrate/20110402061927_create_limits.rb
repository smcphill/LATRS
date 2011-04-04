class CreateLimits < ActiveRecord::Migration
  def self.up
    create_table :limits do |t|
      t.string :name
      t.integer :field_id

      t.timestamps
    end
  end

  def self.down
    drop_table :limits
  end
end
