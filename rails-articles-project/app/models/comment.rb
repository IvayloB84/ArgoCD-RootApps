# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :article
  validates :body, presence: true, length: { minimum: 10 }
end