class Users::LineCallbacksController < ApplicationController
  before_action :authenticate, only: [:callback]

  def line_login
    base_uri   = 'https://access.line.me/oauth2/v2.1/authorize?'
    auth_state = SecureRandom.alphanumeric
    query_str  = line_authorization_query(auth_state)

    session[:line_auth_state] = auth_state
    redirect_to base_uri + query_str
  end

  def callback
    response = request_access_token(params[:code])
    payload  = fetch_payload(response)
    email    = payload['email']
    line_id  = payload['sub']
    user     = User.from_line_login(email, line_id)

    sign_in_and_redirect user
    flash[:notice] = 'LINE アカウントによる認証に成功しました。'
  end

  private

  def callback_uri
    if Rails.env.production?
      request.protocol + request.host + users_line_callbacks_path
    else
      request.protocol + '127.0.0.1' + users_line_callbacks_path
    end
  end

  def line_authorization_query(state)
    request_params = {
      response_type: 'code',
      redirect_uri:  callback_uri,
      client_id:     credentials.line_api[:login][:channel_id],
      state:         state,
      scope:         'openid email'
    }

    request_params.to_query
  end

  def request_access_token(code)
    uri    = 'https://api.line.me/oauth2/v2.1/token'
    params = {
      grant_type:    'authorization_code',
      code:          code,
      redirect_uri:  callback_uri,
      client_id:     credentials.line_api[:login][:channel_id],
      client_secret: credentials.line_api[:login][:channel_secret_id]
    }

    post_request(uri, **params)
  end

  def post_request(url, **params)
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri)

    req.set_form_data(**params) if params.any?

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  def fetch_payload(access_token_res)
    access_token_json = JSON.parse(access_token_res.body, symbolize_names: true)
    id_token          = access_token_json[:id_token]
    secret_id         = credentials.line_api[:login][:channel_secret_id]

    JWT.decode(id_token, secret_id).first
  end

  def authenticate
    if params[:error]
      render controller: :sessions, action: :new
    elsif params[:code]
      query_state = params[:state]
      auth_state  = session[:line_auth_state]
      auth_result = ActiveSupport::SecurityUtils.secure_compare(query_state, auth_state)
      session[:line_auth_state].clear

      render_bad_request unless auth_result
    end
  end
end
