class AddDefaultToLimits < ActiveRecord::Migration
  def self.up
    add_column :limits, :is_default, :boolean
  end

  def self.down
    remove_column :limits, :is_default
  end
end
