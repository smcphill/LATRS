class AddPositionToField < ActiveRecord::Migration
  def self.up
    add_column :fields, :position, :integer
  end

  def self.down
    remove_column :fields, :position
  end
end
