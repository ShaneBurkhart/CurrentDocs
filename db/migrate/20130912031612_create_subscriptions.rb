class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :stripe_customer_id
      t.integer :user_id
      t.string :name
      t.string :address
      t.string :address_2
      t.string :city
      t.string :zipcode
      t.string :state

      t.timestamps
    end
  end
end
