# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :status do
    member
    stage
    code "MyString"
    created_by
  end

end
