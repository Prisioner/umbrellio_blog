class PostHandlerSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :ip, :username
end
