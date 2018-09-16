FactoryGirl.define do
  factory :product_category do
    name Faker::Name.first_name
  end

  factory :api_category, class: "ProductCategory" do
    name "A Category"
  end
end
