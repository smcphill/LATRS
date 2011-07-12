class UpdateTestableitems < ActiveRecord::Migration
  def self.up
    add_column :testableitems, :name, :string
    add_column :testableitems, :type, :string
    add_column :testableitems, :label, :string
    remove_column :testableitems, :field_id
  end

  def self.down
    remove_column :testableitems, :name
    remove_column :testableitems, :type
    remove_column :testableitems, :label
    add_column :testableitems, :field_id, :integer
  end
end
