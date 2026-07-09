# app/models/article.rb
class Article < ApplicationRecord
  # ADDED: Establishes a one-to-many relationship with the comment model
  has_many :comments, dependent: :destroy
end