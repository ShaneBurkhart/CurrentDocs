class AddPageSizeToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :page_size, :string
  end
end
