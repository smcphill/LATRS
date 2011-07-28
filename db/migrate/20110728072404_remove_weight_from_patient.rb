class RemoveWeightFromPatient < ActiveRecord::Migration
  def self.up
    remove_column :patients, :weight
  end

  def self.down
  end
end
