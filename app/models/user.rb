# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
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
#  first_name             :string(255)
#  last_name              :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  type                   :string(255)
#

class User < ActiveRecord::Base

  has_many :jobs
  has_many :shares
  has_many :shared_jobs, through: :shares, source: :job
  # Include default devise modules. Others available are:
  # , :confirmable,
  # :lockable, :timeoutable and :omniauthable :confirmable,:invitable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password,
   :password_confirmation, :remember_me, :type, :guest

  validates :type, :first_name, :last_name, presence: true
  before_validation :check_type

  before_destroy :destroy_shares
  before_destroy :destroy_jobs

  before_save :ensure_authentication_token!

  delegate :can?, :cannot?, :to => :ability
  def ability
    @ability ||= Ability.new(self)
  end

  def self.new_guest_user(share_param, pass)
    Manager.new first_name: "New", last_name: "User",
      email: share_param["email"],
      password: pass, password_confirmation: pass
  end

  def send_share_notification(share, guest, pass)
    UserMailer.share_notification(share.user, share, guest, pass).deliver
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def manager?
  	self.class == Manager
  end

  def viewer?
  	self.class == Viewer
  end

  def admin?
    self.class == Admin
  end

  def is_my_token(token)
    share = Share.find_by_token(token)
    return !share.nil? || is_my_share(share)
  end

  def can_share_job job
    return true if is_my_job job
    share = Share.find_by_job_id_and_user_id job.id, self.id
    return false if share.nil?
    return true if share.can_reshare
  end

  def is_my_job(job)
    job.user.id == self.id
  end

  def is_my_plan(plan)
    is_my_job plan.job
  end

  def is_my_share(share)
    is_being_shared(share) || is_my_job(share.job)
  end

  def is_being_shared(share)
    share.user.id == self.id
  end

  def is_shared_job(job)
    self.shared_jobs.each do |j|
      return true unless j != job
    end
    false
  end

  def is_shared_plan(plan)
    is_shared_job plan.job
  end

  def self.avatar_url email
    hash = Digest::MD5.hexdigest(email.strip)
    "http://www.gravatar.com/avatar/#{hash}?s=200&d=mm"
  end

  private

    def destroy_shares
      self.shares.each do |share|
        share.destroy
      end
    end

    def destroy_jobs
      self.jobs.each do |job|
        job.destroy
      end
    end

    def check_type
      self.type = self.type || "Viewer"
      errors.add(:type, 'Not a valid type') unless self.type == "Manager" || self.type == "Viewer"
    end
end
