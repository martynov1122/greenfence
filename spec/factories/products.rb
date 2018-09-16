FactoryGirl.define do
  factory :product do
    sequence(:name) {|x| Faker::Company.name + x.to_s }
    product_category { create(:product_category, name: 'Eggs') }

    factory :product_fresh_eggs do
      name 'Eggs Fresh Eggs'
    end

    factory :product_organic_eggs do
    	name 'Organic Fresh Eggs'
    end

    factory :product_liquid_eggs do
      name 'Pasteurized Liquid Eggs and Analogues'
    end
  end
end
