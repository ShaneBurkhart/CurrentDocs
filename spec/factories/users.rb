FactoryBot.define do
  factory :user do
    first_name "Shane"
    last_name "Burkhart"
    company "Shane Burkhart LLC"
    sequence(:email) { |n| "shane+#{n}@currentdocs.com" }
    password "password"
    password_confirmation "password"
  end
end
