class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :phone, :token
end
