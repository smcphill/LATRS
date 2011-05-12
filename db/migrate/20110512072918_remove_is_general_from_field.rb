class RemoveIsGeneralFromField < ActiveRecord::Migration
  def self.up
    remove_column :fields, :is_general
  end

  def self.down
    add_column :fields, :is_general, :boolean
  end
end
