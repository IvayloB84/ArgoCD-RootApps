# app/models/comment.rb
class Comment < ApplicationRecord
  # VERIFY: This links every comment back to its parent article
  belongs_to :article
end