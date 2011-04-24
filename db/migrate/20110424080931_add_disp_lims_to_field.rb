class AddDispLimsToField < ActiveRecord::Migration
  def self.up
    add_column :fields, :par_hi_lim, :string
    add_column :fields, :par_lo_lim, :string
  end

  def self.down
    remove_column :fields, :par_lo_lim
    remove_column :fields, :par_hi_lim
  end
end
