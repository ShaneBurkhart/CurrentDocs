class User < ActiveRecord::Base
  include UserRoles

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_many :jobs
  has_many :open_jobs, class_name: "Job", foreign_key: "user_id", conditions: { is_archived: false }
  has_many :archived_jobs, class_name: "Job", foreign_key: "user_id", conditions: { is_archived: true }

  has_many :share_links

  devise :database_authenticatable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  # We're adding these because #share_links.build adds the  unsaved record
  # to share_links when we are just using it to check CanCan permissions.
  def new_share_link
    s = ShareLink.new
    s.user_id = self.id
    return s
  end

  def new_job
    j = Job.new
    j.user_id = self.id
    return j
  end
end
