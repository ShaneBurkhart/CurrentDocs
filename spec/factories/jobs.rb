require 'faker'

FactoryBot.define do
  factory :job do
    user
    name { Faker::Address.street_address }
  end
end
