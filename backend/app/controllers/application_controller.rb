class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Lineable

  def credentials
    Rails.application.credentials
  end

  def success_json
    { success: true }
  end

  # default return is self.
  def convert_embed(params)
    embed = params[:embed]
    embed.nil? ? '*' : embed
  end

  def render_success(code, json = {}, include = '', location: nil)
    response.headers['Access-Control-Expose-Headers'] = 'Location' if location

    render status: code, json: json, include: include, location: location
  end

  def render_error(code, error_params)
    json = {
      error: true,
      error_params: error_params
    }

    render status: code, json: json
  end

  # OK
  def render_200(response_json, params = { embed: '' })
    include = convert_embed(params)
    render_success(200, response_json, include)
  end

  # Created
  def render_201(message, include = '', location: nil)
    render_success(201, message, include, location: location)
  end

  # No content
  def render_204
    render_success(204, {})
  end

  # Bad request
  # invalid data
  def render_400(invalid_record)
    render_error(400, invalid_record.errors.messages)
  end

  # Signature error
  def render_bad_request
    render status: 400, json: { status: 400, message: 'Bad request' }
  end

  # Not found
  def render_404(invalid_record)
    render_error(404, invalid_record.errors.messages)
  end

  # Unprocessable entity
  # validation error
  def render_422(invalid_record)
    render_error(422, invalid_record.errors.messages)
  end
end
