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
#  authentication_token   :string(255)
#  stripe_customer_id     :string(255)
#

class User < ActiveRecord::Base

  has_many :jobs
  has_many :shares
  has_many :shared_jobs, through: :shares, source: :job
  has_many :user_contact_connection, class_name: "Contact", foreign_key: "user_id"
  has_many :contacts, through: :user_contact_connection

  # Include default devise modules. Others available are:
  # , :confirmable,
  # :lockable, :timeoutable and :omniauthable :confirmable,:invitable,
  # :token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password,
   :password_confirmation, :remember_me, :guest, :company, :authentication_token

  validates :authentication_token, :first_name, :last_name, :company, presence: true
  validate :check_type

  before_destroy :destroy_shares
  before_destroy :destroy_jobs

  before_validation :generate_token

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def self.new_guest_user(share_param, pass)
    Viewer.new first_name: "New", last_name: "User",
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

  def has_type?
    return self.type == "Viewer" || self.type == "Manager"
  end

  def subscribe(stripe_token)
    c = Stripe::Customer.create(
      :description => self.email,
      :card => stripe_token
    )
    self.stripe_customer_id = c.id
    c.update_subscription :plan => "manager"
    self.type = "Manager"
    self.cancelled = false
    save
  end

  def cancel_subscription
    return unless self.stripe_customer_id
    c = Stripe::Customer.retrieve self.stripe_customer_id
    begin
      c.cancel_subscription at_period_end: true
    rescue Exception
    end
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

  def expire # Account has expired so we will set expired flag to true
    if self.cancelled
      self.cancelled = false
      self.type = "Viewer"
    else
      self.expired = true
    end
    self.save
  end

  private

    def generate_token
      self.authentication_token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless User.exists?(authentication_token: random_token)
      end
    end

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
      errors.add(:type, 'Not a valid type') unless self.type == "Admin" || self.type == "Manager" || self.type == "Viewer" || self.type == nil
    end
end
