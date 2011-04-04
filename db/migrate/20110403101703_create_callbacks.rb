class CreateCallbacks < ActiveRecord::Migration
  def self.up
    create_table :callbacks do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
  end

  def self.down
    drop_table :callbacks
  end
end
