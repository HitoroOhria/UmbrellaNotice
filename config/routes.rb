Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'static_pages#home'
  get 'line/callback', to: 'lines#callback'

  resources :weathers, only: [:new]
end
