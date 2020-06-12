Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get  'about',                to: 'static_pages#about'
  get  'policy',               to: 'static_pages#policy'
  get  'terms',                to: 'static_pages#terms'
  get  'weathers/information', to: 'weathers#information'
  post 'weathers/trigger',     to: 'weathers#trigger'
  post 'weathers/line_notice', to: 'weathers#line_notice'
  post 'lines/webhock',        to: 'line_api#webhock'
  post 'calendars/callback',   to: 'calendars#callback'

  resources :users, only: [:show]
end
