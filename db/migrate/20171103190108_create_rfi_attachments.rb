class CreateRFIAttachments < ActiveRecord::Migration
  def change
    create_table :rfi_attachments do |t|
      t.string :filename
      t.string :s3_path
      t.integer :rfi_id

      t.timestamps
    end
  end
end
