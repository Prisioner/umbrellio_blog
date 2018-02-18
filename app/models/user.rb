class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :user_ips
end
