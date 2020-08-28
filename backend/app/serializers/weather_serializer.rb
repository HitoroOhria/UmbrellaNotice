class WeatherSerializer < ActiveModel::Serializer
  attributes :id, :city, :lat, :lon

  belongs_to :line_user
end
