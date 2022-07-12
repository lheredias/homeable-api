class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :phone, :type, :token
end
