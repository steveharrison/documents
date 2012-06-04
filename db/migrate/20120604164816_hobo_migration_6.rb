class HoboMigration6 < ActiveRecord::Migration
  def self.up
    add_column :documents, :uuid, :string
    remove_column :documents, :avatar_file_name
    remove_column :documents, :avatar_content_type
    remove_column :documents, :avatar_file_size
    remove_column :documents, :avatar_updated_at
    remove_column :documents, :attachment_content_type
    remove_column :documents, :attachment_file_size
  end

  def self.down
    remove_column :documents, :uuid
    add_column :documents, :avatar_file_name, :string
    add_column :documents, :avatar_content_type, :string
    add_column :documents, :avatar_file_size, :integer
    add_column :documents, :avatar_updated_at, :datetime
    add_column :documents, :attachment_content_type, :string
    add_column :documents, :attachment_file_size, :integer
  end
end
