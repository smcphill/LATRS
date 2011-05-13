class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.integer :position
      t.integer :template_id

      t.timestamps
    end

    Template.all.each do |t|
      g = Group.create (:template_id => t.id, :name=> "_default", :description => "the default group cannot be deleted and will allways be displayed first", :position => 1)
      g.save
    end
    
    rename_column :fields, :template_id, :group_id
  end

  def self.down
    rename_column :fields, :group_id, :template_id
    drop_table :groups
  end
end
