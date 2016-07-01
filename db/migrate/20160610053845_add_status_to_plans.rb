class AddStatusToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :status, :string
    
  end
end
