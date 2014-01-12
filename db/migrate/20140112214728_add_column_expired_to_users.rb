class AddColumnExpiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expired, :boolean, default: false
  end
end
