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

user = User.new(
    email: "shaneburkhart@gmail.com",
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    company: Faker::Company.name
)
user.type = "Admin"
user.save

(1..15).each do
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
    user_id: user.id,
    contact_id: u.id
  )
end

(1..10).each do
  job = Job.create(
            user_id: user.id,
            name: Faker::Address.street_address,
            archived: [true, false].sample
  )

  (1..10).each do |i|
    Plan.create job_id: job.id, plan_num: i, plan_name: Faker::Address.secondary_address
  end
end
