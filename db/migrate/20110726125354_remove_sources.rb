class RemoveSources < ActiveRecord::Migration
  def self.up
    remove_column :testables, :source_id
    drop_table :sources
  end

  def self.down
  end
end
