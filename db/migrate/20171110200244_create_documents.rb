class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :original_filename, null: false
      t.string :s3_path, null: false
      t.integer :user_id, null: false

      t.references :document_association, polymorphic: true, index: true

      t.timestamps
    end

    add_index :documents, :s3_path, unique: true
    add_index :documents, :user_id
  end
end
