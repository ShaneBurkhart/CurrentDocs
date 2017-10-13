# We are moving from plan_num to previous_plan_id and next_plan_id.
# Turning plan ordering into doubly linked list.
class AddNextAndPreviousPlanIdToPlans < ActiveRecord::Migration
  def up
    add_column :plans, :previous_plan_id, :integer
    add_column :plans, :next_plan_id, :integer

    # Get all job ids and go through one by one to not overdo memory
    job_ids = Job.pluck(:id)

    job_ids.each do |job_id|
      # For each tab, we need to create a doubly linked list
      Plan::TABS.each do |tab|
        plans = Plan.where(job_id: job_id, tab: tab).order("plan_num ASC")

        plans.each_with_index do |plan, i|
          # First plan in linked list won't have previous_plan_id
          if i != 0
            plan.previous_plan_id = plans[i - 1].id
          end

          # Last plan in linked list won't have next_plan_id
          if i != plans.count - 1
            plan.next_plan_id = plans[i + 1].id
          end

          plan.save
        end
      end
    end

    remove_column :plans, :plan_num
  end

  def down
    # For simplicity, remove previous_plan_id and next_plan_id
    # And order by id, then add plan_num to each in order or id for tab
    remove_column :plans, :previous_plan_id
    remove_column :plans, :next_plan_id
    add_column :plans, :plan_num, :integer

    job_ids = Job.pluck(:id)

    job_ids.each do |job_id|
      # For each tab, we need to create a doubly linked list
      Plan::TABS.each do |tab|
        plans = Plan.where(job_id: job_id, tab: tab).order("id ASC")

        plans.each_with_index do |plan, i|
          # Ordered by id for tab then using that index as plan_num
          plan.plan_num = i + 1
          plan.save
        end
      end
    end
  end
end
