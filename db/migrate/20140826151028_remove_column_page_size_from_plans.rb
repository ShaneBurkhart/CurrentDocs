class RemoveColumnPageSizeFromPlans < ActiveRecord::Migration
  def up
    remove_column :plans, :page_size
  end

  def down
    add_column :plans, :page_size, :string
  end
end
