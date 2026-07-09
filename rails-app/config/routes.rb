# config/routes.rb
Rails.application.routes.draw do
  scope "/rails" do
    # Directs http://localhost:8080/rails or port 3000 to your articles list
    root "articles#index"

    # NESTED RESOURCES: Comments are nested completely inside Articles
    resources :articles do
      resources :comments
    end
  end
end