FactoryGirl.define do
  factory :company do
    sequence(:name) {|x| Faker::Company.name + x.to_s }
    address
  end

  factory :api_company, class: Company do
    name "Hillandale LLC"
    association :address, street1: "1234 Blah Blah St.", locality: "Blah", administrative_area: "BL", postal_code: 92314
  end
end
