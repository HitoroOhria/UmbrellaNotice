user      = User.find_or_create_by!(email: 'test@example.com')
line_user = LineUser.find_or_create_by!(user: user, line_id: Faker::Food.fruits)
Weather.find_or_create_by!(line_user: line_user, city: '渋谷区', lat: 39.96 , lon: 140.85)
# Calendar.create!(user: user)

# LINE API の手動テストのために、ENV['LINE_ID'] があれば LineUser を作成する
if (line_id = ENV['LINE_ID'])
  line_user = LineUser.create!(line_id: line_id)
  Weather.create!(line_user: line_user, city: '渋谷区', lat: 39.96 , lon: 140.85)
end