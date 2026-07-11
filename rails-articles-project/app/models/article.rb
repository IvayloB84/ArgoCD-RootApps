class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy

  # FIXED: Restores your missing Active Storage image attachment configuration
  has_one_attached :image

  # Chronological timeline scopes
  scope :latest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
end

