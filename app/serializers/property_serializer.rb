class PropertySerializer < ActiveModel::Serializer
  # include Rails.application.routes.url_helpers

  attributes :id, :address, :price, :maintenance, :about, :latitude, :longitude, :operation, :property_type, :bedrooms, :bathrooms, :area, :pets, :active, :photos
  has_many :photos

  # def photos
  #   ActiveModel::SerializableResource.new(object.photos,  each_serializer: PhotoSerializer)
  # end
  # def photo
  #   if object.photo.attached?
      
  #     rails_blob_path(object.photo, only_path: true)
      
  #   end
  # end
end
