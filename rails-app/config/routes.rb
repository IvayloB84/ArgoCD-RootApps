# config/routes.rb
Rails.application.routes.draw do
  root "products#index"
  resources :products

  # BACKUP ROUTE: Explicitly maps the cluster prefix directly to your form controller action
  get "/rails/products/new", to: "products#new"
  post "/rails/products", to: "products#create"
end