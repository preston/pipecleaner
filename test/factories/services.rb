# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    name "MyString"
    url "MyString"
    verb "MyString"
    include_basic false
    include_data false
    include_extended false
  end
end
