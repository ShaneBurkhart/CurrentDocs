class PlanRecordArchived < ActiveRecord::Migration
  def up
    add_column :plan_records, :archived, :boolean, :default => false
  end

  def down
    remove_column :plan_records, :archived
  end
end
