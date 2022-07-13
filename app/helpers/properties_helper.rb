module PropertiesHelper
  def query_filter(properties)
    if params[:address]
      properties = properties.where("address ILIKE ?", "%"+ params[:address] +"%")
    end

    if params[:operation]
      properties = properties.where(operation:params[:operation])
    end

    if params[:property_type]
      properties = properties.where(property_type: params[:property_type])
      # Property.where(property_type: ["apartment","house"])
    end

    if params[:pets]
      properties = properties.where(pets: params[:pets])
    end

    if params[:min_price]
      properties = properties.where("price >= ?", params[:min_price])
    end

    if params[:max_price]
      properties = properties.where("price <= ?", params[:max_price])
    end

    if params[:min_area]
      properties = properties.where("area >= ?", params[:min_area])
    end

    if params[:max_area]
      properties = properties.where("area <= ?", params[:max_area])
    end

    if params[:bedrooms]
      properties = properties.where("bedrooms >= ?", params[:bedrooms])
    end

    if params[:bathrooms]
      properties = properties.where("bedrooms >= ?", params[:bathrooms])
    end

    properties
  end
end