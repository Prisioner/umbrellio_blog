class PostHandlerSerializer < ActiveModel::Serializer
  attributes :title, :body, :ip, :username
end
