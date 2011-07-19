class AddMoreFieldsToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :ethnicity, :string
    add_column :patients, :height, :integer
    add_column :patients, :weight, :float
  end

  def self.down
    remove_column :patients, :weight
    remove_column :patients, :height
    remove_column :patients, :ethnicity
  end
end
