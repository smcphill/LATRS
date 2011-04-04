class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :name
      t.boolean :is_general
      t.boolean :is_required
      t.integer :template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end
