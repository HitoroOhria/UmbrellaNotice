user = User.create!(email: 'hogehoge@hoge.com', password: 'foobar', confirmed_at: Time.zone.now)
LineApi.create!(user: user)
WeatherApi.create!(user: user, city: 'osyamanbe', lat:42.53 , lon: 140.31)
