class AddLabelToField < ActiveRecord::Migration
  def self.up
    add_column :fields, :unit_label, :string
    remove_column :fields, :suffix
  end

  def self.down
    remove_column :fields, :unit_label
    add_column :fields, :suffix, :string
  end
end
