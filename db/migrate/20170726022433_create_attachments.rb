class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :filename
      t.string :s3_path
      t.integer :submittal_id

      t.timestamps
    end
  end
end
