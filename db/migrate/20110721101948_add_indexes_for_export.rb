class AddIndexesForExport < ActiveRecord::Migration
  def self.up
    add_index :testables, :datatype
    add_index :testables, :time_in
    add_index :testableitems, :name
  end

  def self.down
    remove_index :testables, :datatype
    remove_index :testables, :time_in
    remove_index :testableitems, :name
  end
end
