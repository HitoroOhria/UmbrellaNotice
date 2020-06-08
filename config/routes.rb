Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get  'static_pages#policy',  to: 'static_pages#policy'
  get  'static_pages#terms',   to: 'static_pages#terms'
  get  'weathers/information', to: 'weathers#information'
  post 'weathers/trigger',     to: 'weathers#trigger'
  post 'weathers/line_notice', to: 'weathers#line_notice'
  post 'line/webhock',         to: 'line_api#webhock'
end
