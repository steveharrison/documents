class HoboMigration3 < ActiveRecord::Migration
  def self.up
    rename_column :documents, :body, :content
    rename_column :documents, :title, :name
  end

  def self.down
    rename_column :documents, :content, :body
    rename_column :documents, :name, :title
  end
end
