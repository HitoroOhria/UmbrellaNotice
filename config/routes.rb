Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get  'weather_api/notice',  to: 'weathers#notice'
  post 'line_api/webhock',     to: 'lines#webhock'
end
