FactoryGirl.define do
  factory :region do
    name "Los Angeles area"
    latitude_degrees "-10"
    longitude_degrees "15"
    radius 50
  end

  factory :api_region_1, class: Region do
    name "Los Angeles Area"
    latitude_degrees "-10"
    longitude_degrees "15"
    radius 50
  end

  factory :api_region_2, class: Region do
    name "San Francisco Area"
    latitude_degrees "-25"
    longitude_degrees "10"
    radius 50
  end

  factory :api_region_3, class: Region do
    name "Las Vegas Area"
    latitude_degrees "-30"
    longitude_degrees "30"
    radius 50
  end
end
