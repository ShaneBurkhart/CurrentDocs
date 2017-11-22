class AddUserIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :user_id, :integer, null: false
  end
end
