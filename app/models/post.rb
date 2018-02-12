class Post < ApplicationRecord
  belongs_to :user
  has_many :rates, dependent: :destroy

  delegate :username, to: :user

  scope :top, ->(count) { order(rating: :desc).limit(count) }

  def refresh_rating
    new_rating = Rate.where(post: self).average(:rate)
    update(rating: new_rating)
    new_rating
  end
end
