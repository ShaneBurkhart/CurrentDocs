class MoveASIs < ActiveRecord::Migration
  def up
    # Column was a string.  It needs to be text.
    remove_column :asis, :notes
    add_column :asis, :notes, :text

    # Get all job ids and go through one by one to not overdo memory
    job_ids = Job.pluck(:id)

    job_ids.each do |job_id|
      plans = Plan.where(job_id: job_id, tab: "ASI").order("id ASC")

      plans.each do |plan|
        description = nil

        if plan.description
          description_json = JSON.parse(plan.description)
          description = description_json["ops"].first["insert"]
        end

        code = plan.code.gsub("ASI-", "")

        asi = ASI.create(
          job_id: job_id,
          user_id: plan.job.user_id,
          status: "Closed",
          subject: plan.plan_name,
          asi_num: code,
          notes: description,
          plan_sheets_affected: plan.tags
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
