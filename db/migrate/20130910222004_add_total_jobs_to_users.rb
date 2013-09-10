class AddTotalJobsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_jobs, :integer, default: 0
  end
end
