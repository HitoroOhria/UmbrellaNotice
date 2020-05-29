FactoryBot.define do
  factory :base_awether do
    city { 'shibuya' }
    lat  { 35.65 }
    lon  { 139.70 }

    factory :weather do
      association :user
      association :line_user
    end
  end
end
