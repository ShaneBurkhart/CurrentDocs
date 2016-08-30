require 'colorize'

# NotificationSubscription.create(target_id:1, target_type:'job', user_id:1)
class NotificationSubscription < ActiveRecord::Base
  attr_accessible :is_active, :target_action, :target_id, :target_type, :user_id

  belongs_to :user

  # Be aware of a user requesting no email notifications
  # Be aware of manager refusing notifications to a user
  def self.notify(event)
    # subs = NotificationSubscription.joins("LEFT OUTER JOIN users on users.id = notification_subscriptions.user_id").where(:target_id => event.target_id,
    # :target_type => event.target_type)
    subs = NotificationSubscription.where(:target_id => event.target_id,
    :target_type => event.target_type)

    # puts "subs: #{subs.inspect}"

    subs.each do |sub|
      puts "Sending email! event_id:#{sub.inspect}".blue
      NotificationMailer.test_email(sub.user).deliver
    end

  end
end
