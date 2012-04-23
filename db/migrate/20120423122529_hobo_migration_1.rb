class HoboMigration1 < ActiveRecord::Migration
  def self.up
    add_column :documents, :title, :string
    add_column :documents, :body, :text
    change_column :documents, :created_at, :datetime, :null => true
    change_column :documents, :updated_at, :datetime, :null => true
  end

  def self.down
    remove_column :documents, :title
    remove_column :documents, :body
    change_column :documents, :created_at, :datetime, :null => false
    change_column :documents, :updated_at, :datetime, :null => false
  end
end
