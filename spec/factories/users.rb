FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "example_#{n}@example.com" }
    password { 'foobar' }
    confirmed_at { Time.zone.now }

    factory :user_with_weather do
      association :base_weather
    end
  end
end
