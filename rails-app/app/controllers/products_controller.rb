class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  # ADDED: Initializes a blank product instance object for your HTML form layout
  def new
    @product = Product.new
  end

  # ADDED: Captures the submitted form data fields and saves them to your disk
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # ADDED: Strong parameters security gate to prevent malicious data injections
  def product_params
    params.expect(product: [ :name ])
  end
end