class Post < ApplicationRecord
  belongs_to :user
  has_many :rates, dependent: :destroy

  delegate :username, to: :user

  scope :top, ->(count) { order_by(:rating).limit(count) }
end
