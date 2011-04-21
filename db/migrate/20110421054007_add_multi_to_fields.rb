class AddMultiToFields < ActiveRecord::Migration
  def self.up
    add_column :fields, :is_multi, :boolean
  end

  def self.down
    remove_column :fields, :is_multi
  end
end
