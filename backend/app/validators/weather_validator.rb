class WeatherValidator < ApplicationValidator
  attr_accessor :update_flag # flag of #update.
  attr_accessor :id
  attr_accessor :city
  attr_accessor :lat
  attr_accessor :lon
  attr_accessor :embed

  validates :id, numericality: true, presence: true

  validates :lat,
            numericality: {
              greater_than_or_equal_to: -90,
              less_than_or_equal_to: 90,
              message: ->(obj, _data) { obj.error_msg[:LAT][:VALIDATE] }
            },
            if: :lat

  validates :lon,
            numericality: {
              greater_than_or_equal_to: -180,
              less_than_or_equal_to: 180,
              message: ->(obj, _data) { obj.error_msg[:LON][:VALIDATE] }
            },
            if: :lon

  validates :embed,
            format: { with: EMBED_REGEX, message: ERROR_MSG[:EMBED][:VALIDATE] },
            if: :embed

  # validate #update.
  validate :attributes
  validate :city_and_cover_coord
  validate :coord

  # --------------------  validate method  --------------------

  # error if update_params is all blank.
  def attributes
    return if update_flag.nil? || update_params.present?

    add_error(:attributes, error_msg[:ATTRIBUTES][:UPDATE_BLANK][update_attrs])
  end

  # error if city can't call Geocoding API.
  # overwrite @lat and @lon if above is　success.
  def city_and_cover_coord
    return unless city_and_cover_coord_conditions

    if (coord = Weather.new(city: city).city_to_coord)
      self.lat = coord[:lat]
      self.lon = coord[:lon]
    else
      add_error(:city, error_msg[:CITY][:NOT_SEARCH][city])
    end
  end

  # update_flag is true and city is present.
  def city_and_cover_coord_conditions
    update_flag && city
  end

  # can't be blank both @lat and @lon.
  def coord
    return unless coord_conditions

    add_error(:lat, error_msg[:LAT][:BLANK]) unless lat
    add_error(:lon, error_msg[:LON][:BLANK]) unless lon
  end

  # update_flag is true, and not nil both @lat and @lon, and not present both @lat and @lon.
  def coord_conditions
    update_flag && !(lat.nil? && lon.nil?) && !(lat && lon)
  end

  # --------------------------  end  --------------------------

  class << self
    def init_with(params)
      params      = params.permit(:id, :city, :lat, :lon, :embed)
      params[:id] = params[:id].to_i
      new(params)
    end
  end

  # @return [User | NilClass] nil when record not found.
  def find_by_id
    Weather.find_by!(id: id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND][id])
  end

  # (1) @update_flag to true.
  # (2) validate about update.
  def update
    self.update_flag = true
    return if !(weather = find_by_id) || invalid?

    weather.update(update_params) ? weather : fetch_errors_from(weather)
  end

  def destroy
    return  unless (weather = find_by_id)

    self.id = weather.id
    Weather.destroy(weather.id)
  rescue ActiveRecord::RecordNotFound
    add_error(:id, error_msg[:ID][:NOT_FOUND][id])
  end
end
