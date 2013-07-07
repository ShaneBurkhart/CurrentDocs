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
#  name                   :string(255)
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
  has_many :assignments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable :confirmable,
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password,
   :password_confirmation, :remember_me, :type, :guest

  def self.new_guest_user(share_param)
    pass = ('a'..'z').to_a.shuffle[0,8].join
    Viewer.new name: "New User", email: share_param["email"],
      password: pass, password_confirmation: pass
  end

  def send_share_notification(share, guest)
    if guest
      puts "Guest User Email"
    else
      puts "User Email"
    end
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

end
