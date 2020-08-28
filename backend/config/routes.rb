Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :users,
                only: %i[create show update destroy],
                param: :email,
                email: /[^\/]+/ do
        member do
          post 'relate_line_user'
        end
      end

      resources :line_users, only: %i[show update destroy]

      resources :weathers,   only: %i[show update destroy]

      resource :weather_information, only: [] do
        post 'trigger'
        post 'line_notice'
      end

      resource :line_api, only: [] do
        post 'webhock'
      end

    end
  end
end
