FactoryGirl.define do
  factory :activities_viewer do
    viewer { create(:user) }
  end
end
