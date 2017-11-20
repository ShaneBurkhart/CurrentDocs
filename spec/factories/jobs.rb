require 'faker'

FactoryBot.define do
  factory :job do
    user
    name { Faker::Address.street_address }

    factory :archived_job do
      archived true
    end
  end
end
