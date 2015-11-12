class AddCanShareLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_share_link, :boolean, default: false
  end
end
