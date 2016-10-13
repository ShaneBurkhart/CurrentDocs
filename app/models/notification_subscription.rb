include Common

# NotificationSubscription.create(target_id:1, target_type:'job', user_id:1)
class NotificationSubscription < ActiveRecord::Base
  attr_accessible :is_active, :target_action, :target_id, :target_type, :user_id
  belongs_to :user

  validates :target_id, :target_type, :user_id, :presence => true
  validates_presence_of :token, on: :before_create

  validates :target_action, uniqueness: { scope: [:target_type, :target_id, :user_id], message:"this user is already subscribed to this event's particular action"}
  before_save :sanitize_data
  before_validation :generate_token

  # Be aware of a user requesting no email notifications
  # Be aware of manager refusing notifications to a user


  def self.notify(event)
    # Exit if target action is not valid
    unless NOTIF_ACTIONS_LIST.include? event.target_action
      return
    end

    # If event is a plan, update job subscribers
    if event.target_type == NOTIF_TARGET_TYPE[:plan]
      job = Plan.find(event.target_id).job
    else
      job = event
    end

    # Send emails to all subscribers
    subs = NotificationSubscription.where(:target_id => job.id,
    :target_type => job.class.name.downcase, is_active:true)
    subs.each do |sub|
      NotificationMailer.notification_email(event, job, sub).deliver # Plan
    end
  end

  def self.user_is_subscribed(params)
    return false if(NOTIF_TARGET_TYPE_LIST.exclude? params[:target_type])
    if ! NotificationSubscription.where(target_type:'job', target_id:params[:target_id], user_id:params[:user_id], is_active:true).empty?
      return true
    else
      return false
    end
  end

  def self.get_notifs_for_target(params)
    NotificationSubscription.where(target_type:params[:type], target_id:params[:id], user_id:params[:user_id])
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(10, false) # Length is 4/3 of n, see docs
      break random_token unless NotificationSubscription.exists?(token: random_token)
    end
  end

  private
  def sanitize_data
    self.target_type.downcase!
    self.target_action.downcase! if self.target_action.present?
  end


end
