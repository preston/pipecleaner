# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    pipeline_id 1
    name "MyString"
    description "MyText"
    number 1
  end
end
