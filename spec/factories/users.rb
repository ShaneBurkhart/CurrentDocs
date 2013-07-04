# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :manager do
    name 'Manager'
    email 'manager@example.com'
    password 'password'
    password_confirmation 'password'
    # required if the Devise Confirmable module is used
    #confirmed_at Time.now
  end

  factory :viewer do
    name 'Viewer'
    email 'viewer@example.com'
    password 'password'
    password_confirmation 'password'
    # required if the Devise Confirmable module is used
    #confirmed_at Time.now
  end
end
