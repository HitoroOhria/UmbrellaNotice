# FactoryBot.define do
#   factory :base_weather, class: Weather do
#     city { '渋谷区' }
#     lat  { 35.65 }
#     lon  { 139.70 }
#
#     factory :weather do
#       association :user
#       association :line_user, located_at: Time.zone.now
#     end
#   end
# end
