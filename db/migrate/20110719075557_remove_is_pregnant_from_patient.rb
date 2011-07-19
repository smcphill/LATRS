class RemoveIsPregnantFromPatient < ActiveRecord::Migration
  def self.up
    remove_column :patients, :is_pregnant
  end

  def self.down
    add_column :patients, :is_pregnant, :boolean
  end
end
