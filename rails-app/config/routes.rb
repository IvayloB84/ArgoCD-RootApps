# config/routes.rb
Rails.application.routes.draw do
  scope "/rails" do
    root "products#index"
    resources :products
  end
end