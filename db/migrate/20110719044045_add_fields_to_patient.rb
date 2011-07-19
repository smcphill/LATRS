class AddFieldsToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :location, :text
    add_column :patients, :is_pregnant, :boolean
    add_column :patients, :gender, :string
    add_column :patients, :birthdate, :date
  end

  def self.down
    remove_column :patients, :birthdate
    remove_column :patients, :gender
    remove_column :patients, :is_pregnant
    remove_column :patients, :location
  end
end
