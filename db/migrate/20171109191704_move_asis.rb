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
          status: "Closed",
          subject: plan.plan_name,
          asi_num: plan.code,
          notes: plan.description,
          plan_sheets_affected: plan.tag
        )

        break if !asi

        ASIAttachment.create(
          asi_id: asi.id,
          filename: plan.plan_file_name,
          s3_path: plan.plan.path
        )

        # Move over history
        plan.plan_records.each do |plan_record|
          ASIAttachment.create(
            asi_id: asi.id,
            filename: plan_record.plan_record_file_name,
            s3_path: plan_record.plan_record.path
          )
        end
      end
    end
  end

  def down
  end
end
