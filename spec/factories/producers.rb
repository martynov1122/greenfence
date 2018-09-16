FactoryGirl.define do
  factory :producer do
    sequence(:name) {|x| Faker::Company.name + x.to_s }
    address
  end

  factory :api_producer, class: Producer do
    address { create(:address,
                      street1: "123 Easy Street",
                      street2: "",
                      locality: "GREEN FOREST",
                      administrative_area: "OH",
                      postal_code: "72638",
                      latitude_degrees: "36.3354",
                      longitude_degrees: "-93.4372") }

    gfsi_status "red"
    name "CAL MAINE FOODS, INC."
  end

  factory :api_producer_2, class: Producer do
    address { create(:address,
                      street1: "123 different location",
                      street2: "",
                      locality: "A place",
                      administrative_area: "CA",
                      postal_code: "12345",
                      latitude_degrees: "36.3354",
                      longitude_degrees: "-93.4372") }

    gfsi_status "green"
    name "Another producer"
  end

  factory :api_producer_3, class: Producer do
    address { create(:address,
                      street1: "123 different location",
                      street2: "",
                      locality: "A place",
                      administrative_area: "CA",
                      postal_code: "12345",
                      latitude_degrees: "36.3354",
                      longitude_degrees: "-93.4372") }

    gfsi_status "green"
    name "A third producer"
  end

  factory :invited_producer, class: Producer do
    sequence(:name) { |x| "Invited producer #{x}" }
  end
end
