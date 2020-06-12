user = User.create!(email: 'test@example.com', password: 'example', confirmed_at: Time.zone.now)
line_user = LineUser.create!(line_id: '123hoge')
Weather.create!(user: user, line_user: line_user, city: 'shibuya', lat: 42.53 , lon: 140.31)
Calendar.create!(user: user)