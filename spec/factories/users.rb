FactoryBot.define do
  factory :user do
    first_name "Shane"
    last_name "Burkhart"
    company "Shane Burkhart LLC"
    email "shane@currentdocs.com"
    password "password"
    password_confirmation "password"
  end
end
