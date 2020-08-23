Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create show update destroy], param: :email, email: /[^\/]+/
      resources :line_users, only: %i[show update destroy]
      resources :weathers, only: %i[show update destroy]

      post 'weather_information/trigger',     to: 'weathers#trigger'
      post 'weather_information/line_notice', to: 'weathers#notice'
      post 'line/webhock',                    to: 'line_api#webhock'
    end
  end
end
