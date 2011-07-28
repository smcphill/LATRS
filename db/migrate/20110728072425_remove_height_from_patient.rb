class RemoveHeightFromPatient < ActiveRecord::Migration
  def self.up
    remove_column :patients, :height
  end

  def self.down
  end
end
