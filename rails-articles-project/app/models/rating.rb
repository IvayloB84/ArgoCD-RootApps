class Rating < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :score, presence: true, inclusion: { in: 1..5 }
  
  # PERMANENT LOCK: A user can only have exactly ONE rating row per article_id for all time
  validates :user_id, uniqueness: { scope: :article_id, message: "has already rated this article." }
end

