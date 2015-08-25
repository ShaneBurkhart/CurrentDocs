class AddColumnArchivedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :archived, :boolean, default: false
  end
end
