FactoryBot.define do
  factory :line_user, class: LineUser do
    line_id     { SecureRandom.alphanumeric }
    notice_time { '07:00' }

    factory :line_user_with_weather do
      located_at { Time.zone.now }
      association :base_weather
    end
  end
end
