FactoryGirl.define do
  factory :address do
    street1 Faker::Address.street_address
    locality Faker::Address.city
    administrative_area Faker::Address.state_abbr
    postal_code Faker::Address.zip_code.to_i
    longitude_degrees "-15"
    latitude_degrees "15"
  end
end
