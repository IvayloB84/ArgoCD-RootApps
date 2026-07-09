# app/models/product.rb
class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }
end
