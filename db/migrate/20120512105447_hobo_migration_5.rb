class HoboMigration5 < ActiveRecord::Migration
  def self.up
    create_table :documents_tags, :id => false do |t|
      t.integer :document_id
      t.integer :tag_id
    end

    add_column :tags, :name, :string
  end

  def self.down
    remove_column :tags, :name

    drop_table :documents_tags
  end
end
