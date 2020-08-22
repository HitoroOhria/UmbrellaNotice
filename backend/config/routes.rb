Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create show update destory]
      resources :line_users, only: %i[show update destory]
      resources :weathers, only: %i[show update destory]

      post  'weathers/trigger',     to: 'weathers#trigger'
      post  'weathers/line_notice', to: 'weathers#line_notice'
      post  'line/webhock',         to: 'line_api#webhock'
    end
  end
end
