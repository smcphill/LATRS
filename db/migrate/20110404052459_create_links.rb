class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :id
      t.integer :ancestor_id
      t.integer :descendant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
