FactoryBot.define do
  factory :share_link do
    name { Faker::Name.name }
    user { create(:user) }
  end
end
