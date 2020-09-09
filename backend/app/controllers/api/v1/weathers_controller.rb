class Api::V1::WeathersController < ApplicationController
  # GET /api/v1/weathers/:id?embed=*,relate_model2.id
  def show
    weather_validator = WeatherValidator.init_with(params)
    return render_400(weather_validator) if weather_validator.invalid?
    return render_404(weather_validator) unless (@weather = weather_validator.find_by_id)

    render_200(@weather, params)
  end

  # PUT /api/v1/weathers/:id
  # PARAMS city lat lon
  def update
    weather_validator = WeatherValidator.init_with(params)
    return render_400(weather_validator) if weather_validator.invalid?
    return render_400(weather_validator) unless (@weather = weather_validator.update)

    render_200(@weather)
  end

  # DELETE /api/v1/weathers/:id
  def destroy
    weather_validator = WeatherValidator.init_with(params)
    return render_400(weather_validator) if weather_validator.invalid?
    return render_404(weather_validator) unless weather_validator.destroy

    render_204
  end
end
