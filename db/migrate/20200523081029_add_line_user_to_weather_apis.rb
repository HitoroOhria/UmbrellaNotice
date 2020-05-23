class AddLineUserToWeatherApis < ActiveRecord::Migration[5.2]
  def change
    add_reference :weather_apis, :line_user, foreign_key: true
  end
end
