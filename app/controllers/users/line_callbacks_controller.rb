class Users::LineCallbacksController < ApplicationController
  before_action :authenticate, only: [:callback]

  def line_login
    base_url   = 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&'
    auth_state = SecureRandom.alphanumeric
    query_str  = line_authorization_query(auth_state)

    session.delete(:auth_state) if session[:auth_state]
    session[:auth_state] = auth_state

    redirect_to base_url + query_str
  end

  def callback
    response = request_access_token(params[:code])
    payload  = fetch_payload(response)
    line_id  = payload['sub']
    email    = payload['email']
    user     = User.find_or_initialize_by(email: email)

    if user.new_record?
      save_user(user)
      create_relation_model(user, line_id)
    end

    sign_in_and_redirect user
    flash[:notice] = 'LINE アカウントによる認証に成功しました。'
  end

  private

  def callback_url
    if Rails.env.production?
      request.protocol + request.host + users_line_callbacks_path
    else
      request.protocol + '127.0.0.1' + users_line_callbacks_path
    end
  end

  def line_authorization_query(state)
    client_id    = { client_id:    credentials.line_api[:login][:channel_id] }
    redirect_uri = { redirect_uri: callback_url }
    state        = { state:        state }
    scope        = { scope:        'openid email' }

    URI.encode_www_form(**client_id, **redirect_uri, **state, **scope)
  end

  def request_access_token(code)
    url    = 'https://api.line.me/oauth2/v2.1/token'
    params = {
      grant_type:    'authorization_code',
      code:          code,
      redirect_uri:  callback_url,
      client_id:     credentials.line_api[:login][:channel_id],
      client_secret: credentials.line_api[:login][:channel_secret_id]
    }

    post_request(url, **params)
  end

  def post_request(url, **params)
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri)

    req.set_form_data(**params)

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  def fetch_payload(access_token_res)
    access_token_json = JSON.parse(access_token_res.body, symbolize_names: true)
    id_token          = access_token_json[:id_token]
    secret_id         = Rails.application.credentials.line_api[:login][:channel_secret_id]
    JWT.decode(id_token, secret_id)[0]
  end

  def save_user(user)
    user.password     = SecureRandom.alphanumeric
    user.confirmed_at = Time.zone.now
    user.save
  end

  def create_relation_model(user, line_id)
    line_user    = LineUser.find_by(line_id: line_id)
    weather      = line_user.weather
    weather.user = user

    weather.save
    Calendar.create(user: user)
  end

  def authenticate
    if params[:error]
      render controller: :sessions, action: :new
    elsif params[:code]
      query_state = params[:state]
      auth_state  = session[:auth_state]
      return if ActiveSupport::SecurityUtils.secure_compare(query_state, auth_state)

      render_bad_request
    end
  end
end
