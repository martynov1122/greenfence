FactoryGirl.define do
  factory :operation do
  	name "operation 1"
  	description "operation Test 1 created."
  	company { create(:company) }
  end
end