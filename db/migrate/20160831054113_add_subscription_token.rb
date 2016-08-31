class AddSubscriptionToken < ActiveRecord::Migration
  def up
    add_column :notification_subscriptions, :token, :string
    NotificationSubscription.find_each do |subscription|
      if subscription.token.blank?
        subscription.generate_token
        subscription.save
      end
    end
  end

  def down
  end
end
