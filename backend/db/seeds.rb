user      = User.create!(email: 'test@example.com')
# line_user = LineUser.create!(line_id: '123hoge')
# Weather.create!(user: user, line_user: line_user, city: '渋谷区', lat: 39.96 , lon: 140.85)
# Calendar.create!(user: user)

# # LINE 簡易ログインの手動テストのために、ENV['LINE_ID'] があれば LineUser を作成する
# if (line_id = ENV['LINE_ID'])
#   line_user = LineUser.create!(line_id: line_id)
#   Weather.create!(line_user: line_user, city: '渋谷区', lat: 39.96 , lon: 140.85)
# end