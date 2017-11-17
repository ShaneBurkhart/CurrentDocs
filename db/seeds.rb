# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

#puts 'DEFAULT USERS'
#user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#puts 'user: ' << user.name
#user.confirm!
#user.add_role :admin

require 'faker'

@viewer = User.new(
  email: "viewer@plansource.io",
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  company: Faker::Company.name,
  can_share_link: true
)
@viewer.type = "Viewer"
@viewer.save

@manager = User.new(
  email: "manager@plansource.io",
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  company: Faker::Company.name,
  can_share_link: true
)
@manager.type = "Manager"
@manager.save

@project_manager = User.new(
  email: "project_manager@plansource.io",
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  company: Faker::Company.name,
  can_share_link: true
)
@project_manager.type = "Manager"
@project_manager.save

@user = User.find_or_create_by_email(ENV["EMAIL"], {
  email: ENV["EMAIL"],
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  company: Faker::Company.name,
  can_share_link: true
})
@user.type = "Admin"
@user.save

def create_plans_for_job(job)

  if [true, false].sample
    ProjectManager.create(job_id: job.id, user_id: @project_manager.id)
  end

  (1..20).each do |i|
    tab = Plan::TABS.sample
    csi = nil

    if tab == "Shops"
      csi = Faker::Number.number(6)
    end

    plan = Plan.create(
      job_id: job.id,
      name: Faker::Address.secondary_address,
      tab: tab,
      csi: csi
    )

    # Accepted submittals for plan
    if tab == "Shops"
      (1..3).each do |j|
        Submittal.create(
          data: {
            csi_code: Faker::Address.building_number,
            description: Faker::Address.street_address,
          },
          is_accepted: true,
          plan_id: plan.id,
          user_id: @viewer.id,
        )
      end
    end
  end

  # Create RFIs and ASIs
  (1..20).each do |i|
    user_id = [nil, @user.id, @manager.id, @viewer.id].sample
    assigned_user_id = [nil, @user.id, @manager.id, @viewer.id].sample

    rfi = RFI.new(
      job_id: job.id,
      user_id: user_id,
      assigned_user_id: assigned_user_id,
      subject: Faker::Address.street_address
    )

    case rand(1..5)
      when 1
        # 1: RFI, Open, no ASI
        rfi.save

      when 2
        # 2: RFI, Open, ASI
        rfi.save
        ASI.create(
          status: 'Open',
          subject: Faker::Address.street_address,
          job_id: job.id,
          rfi_id: rfi.id,
          user_id: user_id,
        )

      when 3
        # 3: RFI, Closed, ASI
        rfi.save
        ASI.create(
          status: 'Closed',
          subject: Faker::Address.street_address,
          job_id: job.id,
          rfi_id: rfi.id,
          user_id: user_id,
        )

      when 4
        # 4: no RFI, Open, ASI
        ASI.create(
          status: 'Open',
          subject: Faker::Address.street_address,
          job_id: job.id,
          user_id: user_id,
          assigned_user_id: assigned_user_id,
        )

      when 5
        # 5: no RFI, Closed, ASI
        ASI.create(
          status: 'Closed',
          subject: Faker::Address.street_address,
          job_id: job.id,
          user_id: user_id,
          assigned_user_id: assigned_user_id,
        )
      end
  end

  # In review submittals for job
  (0..3).each do |i|
    Submittal.create(
      data: {
        csi_code: Faker::Address.building_number,
        description: Faker::Address.street_address,
      },
      job_id: job.id,
      user_id: @viewer.id,
    )
  end
end

# Make the first viewer an account we can access
Contact.create(
  user_id: @user.id,
  contact_id: @viewer.id
)

# Shared jobs
(1..10).each do |i|
  # Create jobs for user (admin)
  job = Job.create(
    user_id: @user.id,
    name: Faker::Address.street_address,
    archived: [true, false].sample
  )

  create_plans_for_job(job)

  Share.create(
    sharer_id: @user.id,
    user_id: [@viewer.id, @manager.id].sample,
    job_id: job.id,
    can_reshare: false,
    permissions: Random.rand(6) + 1
  )

  ShareLink.create(
    job_id: job.id,
    user_id: @user.id,
    email_shared_with: Faker::Internet.email
  )

  # Create jobs for manager (normal job owner)
  manager_job = Job.create(
    user_id: @manager.id,
    name: Faker::Address.street_address,
    archived: [true, false].sample
  )

  create_plans_for_job(manager_job)

  Share.create(
    sharer_id: @manager.id,
    user_id: [@viewer.id, @user.id].sample,
    job_id: manager_job.id,
    can_reshare: false,
    permissions: Random.rand(6) + 1
  )

  ShareLink.create(
    job_id: manager_job.id,
    user_id: @manager.id,
    email_shared_with: Faker::Internet.email
  )
end

# Create contact for user (admin) and manager
Contact.create(
  user_id: @user.id,
  contact_id: @manager.id
)
Contact.create(
  user_id: @manager.id,
  contact_id: @user.id
)

(1..100).each do
  u = User.new(
    email: Faker::Internet.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    company: Faker::Company.name,
  )
  u.type = "Viewer"
  u.save

  Contact.create(
    user_id: @user.id,
    contact_id: u.id
  )
end


(1..10).each do
  job = Job.create(
    user_id: @user.id,
    name: Faker::Address.street_address,
    archived: [true, false].sample
  )

  create_plans_for_job(job)
end
