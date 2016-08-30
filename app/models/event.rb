include Common
# Event.create(target_type:'job', target_id:1, target_action:'updated', user_id:1)
class Event < ActiveRecord::Base
  attr_accessible :target_action, :target_id, :target_type, :user_id
  belongs_to :user

  validates :target_action, :target_id, :target_type, :user_id, :presence => true
  validate :ensure_valid_target_type, :ensure_valid_target_action

  before_save :sanitize_data
  after_commit :notify_subscribers, :on => :create

  # Send logic to update users to NotificationSubscription
  def notify_subscribers
    NotificationSubscription.notify(self)
  end

  private
  def ensure_valid_target_type
    errors.add(:target_type, "target type is invalid") unless target_type == NOTIF_TARGET_TYPE
  end

  def ensure_valid_target_action
    errors.add(:target_action, "target action is not valid") unless PERMISSIBLE_NOTIF_ACTIONS_LIST.include? target_action
  end

  def sanitize_data
    self.target_type.downcase!
    self.target_action.downcase!
  end
end
