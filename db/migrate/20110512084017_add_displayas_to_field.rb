class AddDisplayasToField < ActiveRecord::Migration
  def self.up
    add_column :fields, :display_as, :string
  end

  def self.down
    remove_column :fields, :display_as
  end
end
