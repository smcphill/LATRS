class Derivative < ActiveRecord::Migration
  def self.up
    create_table :derivatives do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    remove_column :derivatives, :id
  end

  def self.down
    drop_table :derivatives
  end
end
