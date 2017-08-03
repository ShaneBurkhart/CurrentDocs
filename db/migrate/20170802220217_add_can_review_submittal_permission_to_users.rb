class AddCanReviewSubmittalPermissionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_review_submittal, :boolean, default: false
  end
end
