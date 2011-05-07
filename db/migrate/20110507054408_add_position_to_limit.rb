class AddPositionToLimit < ActiveRecord::Migration
  def self.up
    add_column :limits, :position, :integer
  end

  def self.down
    remove_column :limits, :position
  end
end
