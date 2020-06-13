user = User.create!(email: 'test@example.com', password: 'example', confirmed_at: Time.zone.now)
line_user = LineUser.create!(line_id: '123hoge')
Weather.create!(user: user, line_user: line_user, city: '渋谷区', lat: 39.96 , lon: 140.85)
Calendar.create!(user: user)