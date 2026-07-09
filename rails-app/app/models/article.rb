# app/models/article.rb
class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

  # FIXED: Blocks any title or body content shorter than 10 symbols/characters
  validates :title, presence: true, length: { minimum: 10 }
  validates :body,  presence: true, length: { minimum: 10 }
end