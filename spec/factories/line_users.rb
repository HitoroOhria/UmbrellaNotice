FactoryBot.define do
  factory :line_user do
    line_id     { SecureRandom.alphanumeric }
    notice_time { '7:00' }
    located_at  { nil }

    factory :line_user_with_weather do
      located_at { Time.zone.now }
      association :weather
    end
  end
end
