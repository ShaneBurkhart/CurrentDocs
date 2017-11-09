class CreateRFIs < ActiveRecord::Migration
  def change
    create_table :rfis do |t|
    	t.string :rfi_num
    	t.string :subject
    	t.string :notes
      t.datetime :due_date
    	t.integer :job_id
    	t.integer :user_id
    	t.integer :assigned_user_id

      t.timestamps
    end
  end
end
