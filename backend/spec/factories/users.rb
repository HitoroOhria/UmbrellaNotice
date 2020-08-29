FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "example_#{n}@example.com" }

    # factory :user_with_weather do
    #   association :weather, factory: :base_weather
    # end
  end
end
