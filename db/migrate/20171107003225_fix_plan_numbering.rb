# Somehow plan numbering is off for various plans.  This migration goes through
# and fixes them.
class FixPlanNumbering < ActiveRecord::Migration
  def up
    job_ids = Job.pluck(:id)

    job_ids.each do |job_id|
      # For each tab, we need to create a doubly linked list
      Plan::TABS.each do |tab|
        plan_count  = Plan.where(job_id: job_id, tab: tab).count
        first_plan = Plan.where(job_id: job_id, tab: tab, previous_plan_id: nil).count
        last_plan = Plan.where(job_id: job_id, tab: tab, next_plan_id: nil).count

        if plan_count != 0 and (first_plan != 1 or last_plan != 1)
          puts "Fixing Job ID: #{job_id} TAB: #{tab}"

          plans = Plan.where(job_id: job_id, tab: tab)

          plans.each_with_index do |plan, i|
            # First plan in linked list won't have previous_plan_id
            if i == 0
              plan.previous_plan_id = nil
            else
              plan.previous_plan_id = plans[i - 1].id
            end

            # Last plan in linked list won't have next_plan_id
            if i == plans.count - 1
              plan.next_plan_id = nil
            else
              plan.next_plan_id = plans[i + 1].id
            end

            plan.save
          end
        end
      end
    end
  end

  def down
    # Fuck up your data
  end
end
