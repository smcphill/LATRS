class AddDatatypeToTestableitems < ActiveRecord::Migration
  def self.up
    add_column :testableitems, :datatype, :string
    remove_column :testableitems, :type
  end

  def self.down
    remove_column :testableitems, :datatype
    add_column :testableitems, :type, :string
  end
end
