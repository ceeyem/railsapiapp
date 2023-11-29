Rails.application.routes.draw do
  resource :users, only: [:create]
  post "/login", to: "auth#login"
  delete "/logout", to: "auth#destroy"
  get "/auto_login", to: "auth#auto_login"
  namespace :api do
    namespace :v1 do
      resources :questions
      resources :asks
    end
  end

  #  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
