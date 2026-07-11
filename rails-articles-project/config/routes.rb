# config/routes.rb
Rails.application.routes.draw do
  
  scope "/rails" do
    root "articles#index"

    # Scoped Sign Up pathways
    get  "/signup", to: "registrations#new", as: :signup
    post "/signup", to: "registrations#create"

    # FIXED: Added explicit sign-out routing paths to bypass browser thread locks
    get    "/signout", to: "sessions#destroy", as: :signout
    delete "/signout", to: "sessions#destroy"

    # Standard session configuration loops
    resource :session
    resources :passwords, param: :token

    resources :articles do
      resources :comments
  resources :ratings, only: [:create, :destroy] 
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end