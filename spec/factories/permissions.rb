# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    name "create_company?"
    label "Create Company"
    category "company"
  end
end
