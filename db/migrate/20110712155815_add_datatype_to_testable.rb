class AddDatatypeToTestable < ActiveRecord::Migration
  def self.up
    rename_column :testables, :type, :datatype
  end

  def self.down
    rename_column :testables, :datatype, :type
  end
end
