Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get  'weathers/notice',  to: 'weathers#notice'
  post 'line/webhock',     to: 'lines#webhock'
end
