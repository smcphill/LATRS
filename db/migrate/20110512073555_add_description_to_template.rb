class AddDescriptionToTemplate < ActiveRecord::Migration
  def self.up
    add_column :templates, :description, :text
  end

  def self.down
    remove_column :templates, :description
  end
end
