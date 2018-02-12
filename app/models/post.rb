class Post < ApplicationRecord
  belongs_to :user
  has_many :rates, dependent: :destroy

  delegate :username, to: :user

  scope :top, ->(count) { order(:rating).limit(count) }
end
