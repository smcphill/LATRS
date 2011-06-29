class RemoveValueIFromTestableitem < ActiveRecord::Migration
  def self.up
    remove_column :testableitems, :value_i
    rename_column :testableitems, :value_s, :value
  end

  def self.down
    add_column :fields, :is_general, :integer    
  end
end
