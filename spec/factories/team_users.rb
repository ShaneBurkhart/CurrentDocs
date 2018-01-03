FactoryBot.define do
  factory :team_user do
    team { create(:team) }
    user { create(:user) }
    is_owner false

    trait :as_owner do
      is_owner true
    end
  end
end
