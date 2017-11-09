class CreateASIs < ActiveRecord::Migration
  def change
    create_table :asis do |t|
      t.string :asi_num
      t.string :status
    	t.string :subject
    	t.string :notes
    	t.string :plan_sheets_affected
    	t.string :in_addendum
    	t.integer :job_id
    	t.integer :rfi_id
    	t.integer :user_id
    	t.integer :assigned_user_id

      t.timestamps
    end

    # Get all job ids and go through one by one to not overdo memory
    job_ids = Job.pluck(:id)

    job_ids.each do |job_id|
      plans = Plan.where(job_id: job_id, tab: "ASI").order("id ASC")

      plans.each do |plan|
        ASI.create(
          job_id: job_id,
          user_id: plan.job.user_id,
          status: "Open",
          subject: plan.plan_name,
          notes: "Imported from 'ASI' tab."
        )
      end
    end
  end
end
