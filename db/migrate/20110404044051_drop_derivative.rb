class DropDerivative < ActiveRecord::Migration
  def self.up
	drop_table :derivatives
  end

  def self.down
  end
end
