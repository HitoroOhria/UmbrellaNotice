FactoryBot.define do
  factory :base_weather, class: Weather do
    city { '渋谷区' }
    lat  { 35.65 }
    lon  { 139.70 }

    trait :saitama do
      city { 'さいたま市' }
      lat  { 35.86 }
      lon  { 139.65 }
    end

    factory :weather do
      association :line_user, located_at: Time.zone.now
    end
  end
end
