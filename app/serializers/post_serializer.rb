class PostSerializer < ActiveModel::Serializer
  attributes :title, :body, :rating, :username, :ip
end
