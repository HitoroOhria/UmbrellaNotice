Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root  'static_pages#home'
  get   'about',            to: 'static_pages#about'
  get   'policy',           to: 'static_pages#policy'
  get   'terms',            to: 'static_pages#terms'
  match '/oauth2callback',  to: Google::Auth::WebUserAuthorizer::CallbackApp, via: :all

  scope :lines do
    post 'webhock',         to: 'line_api#webhock'
  end

  scope :weathers do
    get  'information',     to: 'weathers#information'
    post 'trigger',         to: 'weathers#trigger'
    post 'line_notice',     to: 'weathers#line_notice'
  end

  resources :users, only: [:show]
end
