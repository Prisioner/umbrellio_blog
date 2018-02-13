class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :username
end
