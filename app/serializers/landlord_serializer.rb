class LandlordSerializer < ActiveModel::Serializer
  attributes :email, :phone, :name
  
  def email
    object.user.email 
  end
  def phone
    object.user.phone 
  end
  def name
    object.user.name 
  end
end
