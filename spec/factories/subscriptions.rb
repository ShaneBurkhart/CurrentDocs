# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    stripe_customer_id "MyString"
    user_id 1
    name "MyString"
    address "MyString"
    address_2 "MyString"
    city "MyString"
    zipcode "MyString"
    state "MyString"
  end
end
