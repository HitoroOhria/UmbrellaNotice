Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get  'weathers/information', to: 'weathers#information'
  post 'weathers/trigger',     to: 'weathers#trigger'
  post 'weathers/notice',      to: 'weathers#notice'
  post 'line/webhock',         to: 'line_api#webhock'
end
