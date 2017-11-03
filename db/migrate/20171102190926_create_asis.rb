class CreateASIs < ActiveRecord::Migration
  def change
    create_table :asis do |t|
      t.string :asi_num
      t.string :status
    	t.string :subject
    	t.string :plan_sheets_affected
    	t.string :in_addendum
    	t.integer :job_id
    	t.integer :rfi_id
    	t.integer :assigned_user_id

      t.timestamps
    end
  end
end
