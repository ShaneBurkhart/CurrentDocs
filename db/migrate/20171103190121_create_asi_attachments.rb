class CreateASIAttachments < ActiveRecord::Migration
  def change
    create_table :asi_attachments do |t|
      t.string :filename
      t.string :s3_path
      t.integer :asi_id

      t.timestamps
    end
  end
end
