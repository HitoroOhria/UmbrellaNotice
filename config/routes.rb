Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root  'static_pages#home'
  get   'about',                to: 'static_pages#about'
  get   'policy',               to: 'static_pages#policy'
  get   'terms',                to: 'static_pages#terms'
  post  'lines/webhock',        to: 'line_api#webhock'
  post  'weathers/trigger',     to: 'weathers#trigger'
  post  'weathers/line_notice', to: 'weathers#line_notice'
  match '/oauth2callback',      to: Google::Auth::WebUserAuthorizer::CallbackApp, via: :all

  namespace :users do
    get  'line_login',          to: 'line_callbacks#line_login'
    get  'line_callbacks',      to: 'line_callbacks#callback'

    resources :line_users,      only: %i[new create]
  end

  resources :users, only: [:show]

  if Rails.env.development?
    get 'weathers/information', to: 'weathers#information'
  end
end
