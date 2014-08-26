class RemoveStripeCustomerId < ActiveRecord::Migration
  def up
    remove_column :users, :stripe_customer_id
  end

  def down
    add_column :users, :stripe_customer_id, :string
  end
end
