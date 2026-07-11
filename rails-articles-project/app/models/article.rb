class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy

  # ACTIVE RECORD ORDERING SCOPES
  scope :latest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  
  # FIXED FOR SQLITE: Explicitly selects the calculated average score as a separate attribute for sorting
  scope :highest_rated, -> {
    left_joins(:ratings)
      .select("articles.*, COALESCE(AVG(ratings.score), 0) AS avg_score")
      .group(:id)
      .order("avg_score DESC, articles.created_at DESC")
  }

  # FIXED FOR SQLITE: Explicitly selects the calculated average score as a separate attribute for sorting
  scope :lowest_rated, -> {
    left_joins(:ratings)
      .select("articles.*, COALESCE(AVG(ratings.score), 0) AS avg_score")
      .group(:id)
      .order("avg_score ASC, articles.created_at DESC")
  }
end
