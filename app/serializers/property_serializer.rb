class PropertySerializer < ActiveModel::Serializer
  attributes :id, :address, :price, :about, :operation, :property_type, :bedrooms, :bathrooms, :area, :pets, :active
end
