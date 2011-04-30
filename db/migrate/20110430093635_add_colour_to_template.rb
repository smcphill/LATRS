class AddColourToTemplate < ActiveRecord::Migration
  def self.up
    add_column :templates, :colour, :string
  end

  def self.down
    remove_column :templates, :colour
  end
end
