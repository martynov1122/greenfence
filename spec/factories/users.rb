FactoryGirl.define do
  factory :user do
    transient do
      role nil
    end

    first_name Faker::Name.first_name
    last_name Faker::Name.last_name

    sequence(:email) {|x| "test#{Time.zone.now.usec}#{x}@test.com"}

    sequence(:username) {|x| "test user #{x}" }
    password "Password#1234"
    password_confirmation "Password#1234"

    company { create(:company) }
    after :create do |user, evaluator|
      user.add_role evaluator.role if evaluator.role
    end

    confirmed_at "#{Time.zone.now}"

    factory :api_user do
      email "root@ibms.com"
      first_name "Crash"
      last_name "Override"
      username "Crash Override"
      last_login_at "2013-04-30T19:31:00Z"


    end

    factory :robert_egg_worker do
      email "robert.egg-worker@ibms.com"
      first_name "Robert"
      last_name "Egg-Worker"
      last_login_at "2013-04-30T19:31:00Z"
    end

    factory :rick_egg_worker do
      first_name "Rick"
      last_name "Egg-Worker"
      username "Rick Egg-Worker"
      email "rick.egg-worker@ibms.com"
      device_id "81cbdb9d2d045d3c2006bdd1d08353e5"
    end

    factory :producer_user do
      company { create(:producer) }
    end
  end

  factory :invited_user, class: 'User' do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name

    sequence(:email) {|x| "invite#{Time.zone.now.usec}#{x}@test.com"}

    company { create(:company) }

    invitation_token { User.invitation_token }
    invitation_sent_at { Time.now }

    factory :invited_producer_admin, class: User do
      company { create(:invited_producer) }

      # http://stackoverflow.com/questions/2937326/populating-an-association-with-children-in-factory-girl
      after :build do |user|
        user.roles << FactoryGirl.build(:role, name: 'producer_admin', resource: user.company)
      end
      after :create do |user|
        user.roles.each do |role|
          role.save!
        end
      end
    end
  end
end
