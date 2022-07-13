class SavedSerializer < ActiveModel::Serializer
  attributes :id, :contacted, :favorite, :property

  def property
    ActiveModel::SerializableResource.new(object.property,  each_serializer: PropertySerializer)
  end
end
