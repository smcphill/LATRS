class AddDatatypeToField < ActiveRecord::Migration
  def self.up
    add_column :fields, :type, :string
  end

  def self.down
    remove_column :fields, :type
  end
end
