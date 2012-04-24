class HoboMigration2 < ActiveRecord::Migration
  def self.up
    add_column :documents, :user_id, :integer

    add_index :documents, [:user_id]
  end

  def self.down
    remove_column :documents, :user_id

    remove_index :documents, :name => :index_documents_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
