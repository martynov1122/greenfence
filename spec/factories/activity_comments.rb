# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_comment do
    text "MyText"
    user_id 1
  end
end
