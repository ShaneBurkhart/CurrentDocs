# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  include UserRoles

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_many :jobs
  has_many :open_jobs, class_name: "Job", foreign_key: "user_id", conditions: { is_archived: false }
  has_many :archived_jobs, class_name: "Job", foreign_key: "user_id", conditions: { is_archived: true }
  belongs_to :team

  has_many :share_links

  devise :database_authenticatable, :trackable, :validatable, :recoverable

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
