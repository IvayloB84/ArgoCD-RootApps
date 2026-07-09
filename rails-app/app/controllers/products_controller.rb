class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]

  def index
    @products = Product.all
  end
end
