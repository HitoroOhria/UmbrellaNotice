user = User.create!(email: 'hogehoge@hoge.com', password: 'foobar', confirmed_at: Time.zone.now)
line_user = LineUser.create!(line_id: '123hoge')
WeatherApi.create!(user: user, line_user: line_user, city: 'osyamanbe', lat:42.53 , lon: 140.31)
