# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pipeline do
    name "MyString"
    description "MyText"
    code "MyString"
    created_by
  end
end
