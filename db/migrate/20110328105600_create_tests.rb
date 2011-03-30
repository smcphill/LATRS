class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string :code
      t.timestamp :time_in
      t.timestamp :time_out
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :tests
  end
end
