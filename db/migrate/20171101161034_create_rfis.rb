class CreateRfis < ActiveRecord::Migration
  def change
    create_table :rfis do |t|
    	t.string :subject
      t.datetime :due_date
    	t.integer :job_id
    	t.integer :assigned_user_id

      t.timestamps
    end
  end
end
