require 'colorize'
include Common

# NotificationSubscription.create(target_id:1, target_type:'job', user_id:1)
class NotificationSubscription < ActiveRecord::Base
  attr_accessible :is_active, :target_action, :target_id, :target_type, :user_id
  validates :target_id, :target_type, :user_id, :presence => true
  validates :target_action, uniqueness: { scope: [:target_type, :target_id, :user_id], message:"this user is already subscribed to this event's particular action"}

  belongs_to :user

  before_save :sanitize_data

  # Be aware of a user requesting no email notifications
  # Be aware of manager refusing notifications to a user
  def self.notify(event)
    unless PERMISSIBLE_NOTIF_ACTIONS_LIST.include? event.target_action
      return
    end
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

  private
  def sanitize_data
    self.target_type.downcase!
    self.target_action.downcase! if self.target_action.present?
  end
end
