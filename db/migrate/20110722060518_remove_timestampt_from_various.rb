class RemoveTimestamptFromVarious < ActiveRecord::Migration
  tables = [:departments, :fields, :groups,
             :limits, :links, :patients, 
             :sources, :templates, :testableitems,
             :testabled]

  def self.up
    tables.each do |t|
      remove_column t, :created_at
      remove_column t, :updated_at      
    end
  end

  def self.down
    tables.each do |t|      
      add_column :departments, :created_at, :datetime
      add_column :departments, :updated_at, :datetime
    end
  end
end
