class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_many :jobs
  has_many :open_jobs, class_name: "Job", foreign_key: "user_id", conditions: { is_archived: false }
  has_many :archived_jobs, class_name: "Job", foreign_key: "user_id", conditions: { is_archived: true }

  has_many :share_links

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
