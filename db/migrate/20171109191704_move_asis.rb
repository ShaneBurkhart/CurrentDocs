class MoveASIs < ActiveRecord::Migration
  def up
    # Get all job ids and go through one by one to not overdo memory
    job_ids = Job.pluck(:id)

    job_ids.each do |job_id|
      plans = Plan.where(job_id: job_id, tab: "ASI").order("id ASC")

      plans.each do |plan|
        asi = ASI.create(
          job_id: job_id,
          user_id: plan.job.user_id,
          status: "Open",
          subject: plan.name,
          notes: "Imported from 'ASI' tab."
        )

        break if !asi

        ASIAttachment.create(
          asi_id: asi.id,
          filename: plan.plan_file_name,
          s3_path: plan.plan.path
        )
      end
    end
  end

  def down
  end
end
