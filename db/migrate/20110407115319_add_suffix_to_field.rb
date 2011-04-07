class AddSuffixToField < ActiveRecord::Migration
  def self.up
    add_column :fields, :suffix, :string
  end

  def self.down
    remove_column :fields, :suffix
  end
end
