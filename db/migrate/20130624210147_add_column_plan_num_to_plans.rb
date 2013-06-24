class AddColumnPlanNumToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :plan_num, :integer
  end
end
