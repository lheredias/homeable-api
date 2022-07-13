class PropertySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :address, :price, :about, :operation, :property_type, :bedrooms, :bathrooms, :area, :pets, :active, :photo

  def photo
    if object.photo.attached?
      
      rails_blob_path(object.photo, only_path: true)
      
    end
  end
end
