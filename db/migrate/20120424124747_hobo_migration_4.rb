class HoboMigration4 < ActiveRecord::Migration
  def self.up
    rename_column :documents, :name, :title
  end

  def self.down
    rename_column :documents, :title, :name
  end
end
