class AddOrderNumToPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :next_plan_id
    remove_column :plans, :previous_plan_id

    add_column :plans, :order_num, :integer, null: false
  end
end
