# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :risk_level do
    name 'Critical'
    sampling_frequency 1.week
  end
end
