require 'faker'

@team = Team.create(
  name: Faker::Company.name
)

@viewer = User.new(
  email: "viewer@plansource.io",
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
)
@viewer.save

@manager = User.new(
  email: "manager@plansource.io",
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
)
@manager.save

@user = User.find_or_create_by_email(ENV["EMAIL"], {
  email: ENV["EMAIL"],
  password: "password",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
})
@user.save

@team.add_user(@viewer)
@team.add_user(@manager)
@team.add_user(@user)

def create_plans_for_job(job)
  (1..20).each do |i|
    tab = Plan::TABS.sample

    plan = Plan.new(name: Faker::Address.secondary_address)
    plan.job_id = job.id
    plan.tab = tab
    plan.save
  end
end

# Shared jobs
(1..10).each do |i|
  # TODO add shared jobs for different users.

  #ShareLink.create(
    #job_id: manager_job.id,
    #user_id: @manager.id,
    #email_shared_with: Faker::Internet.email
  #)
end

(1..10).each do
  job = Job.new(
    name: Faker::Address.street_address,
    is_archived: [true, false].sample,
  )
  job.team_id = @team.id
  job.user_id = @user.id
  job.save

  create_plans_for_job(job)
end
