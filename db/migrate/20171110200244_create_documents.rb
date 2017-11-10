class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :original_filename, null: false
      t.string :s3_path, null: false, unique: true

      t.timestamps
    end
  end
end
