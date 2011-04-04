class MakeNewCallback < ActiveRecord::Migration
  def self.up
    create_table :callbacks do |t|
      t.integer :parent_id
      t.integer :child_id
    end
  end

  def self.down
  end
end
