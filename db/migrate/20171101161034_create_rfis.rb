class CreateRfis < ActiveRecord::Migration
  def change
    create_table :rfis do |t|
    	t.string :status
    	t.string :subject
    	t.string :plan_sheets_affected
    	t.string :in_addendum
      t.datetime :due_date
    	t.integer :job_id
    	t.integer :asi_id
    	t.integer :assigned_user_id

      t.timestamps
    end
  end
end
