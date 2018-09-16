FactoryGirl.define do
  factory :retailer do
    sequence(:name) {|x| Faker::Company.name + x.to_s }
    address
  end

  factory :api_retailer, class: Retailer do
    address { create(:address,
                      street1: "987 Hard Way",
                      street2: "",
                      locality: "ATLANTA",
                      administrative_area: "GA",
                      postal_code: "30301") }

    gfsi_status "red"
    name "Walmart"
  end
end
