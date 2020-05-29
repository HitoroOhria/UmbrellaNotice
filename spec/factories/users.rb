FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example_#{n}@example.com" }
    password { 'foobar' }
    confirmed_at { Time.zone.now }

    factory :user_with_weather do
      located_at { Time.zone.now }
      association :weather
    end
  end
end
