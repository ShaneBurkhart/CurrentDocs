class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.string :filename
      t.datetime :date_taken
      t.string :aws_filename
      t.integer :job_id
      t.integer :upload_user_id

      t.timestamps
    end
  end
end
