Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get  'weather/notice',  to: 'weather_api#notice'
  post 'line/webhock',    to: 'line_api#webhock'
end
