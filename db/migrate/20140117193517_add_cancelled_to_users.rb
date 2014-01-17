class AddCancelledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cancelled, :boolean
  end
end
