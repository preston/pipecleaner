# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    user_id 1
    stage_id 1
    condition "MyString"
    count 1
  end
end
