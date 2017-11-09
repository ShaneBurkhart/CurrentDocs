class MoveASIs < ActiveRecord::Migration
  def up
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

  def down
  end
end
