class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :phone, :user_type, :token
end
