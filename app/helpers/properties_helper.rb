module PropertiesHelper
  def query_filter(properties)

    if params[:address] && !params[:address].empty?
      properties = properties.where("address ILIKE ?", "%"+ params[:address] +"%")
    end

    if params[:operation] && !params[:operation].empty?
      properties = properties.where(operation:params[:operation])
    end

    if params[:property_type] && !params[:property_type].empty?
      properties = properties.where(property_type: params[:property_type])
      # Property.where(property_type: ["apartment","house"])
    end

    if params[:pets] && !params[:pets].empty?
      properties = properties.where(pets: params[:pets])
    end

    if params[:min_price] && !params[:min_price].empty?
      properties = properties.where("price >= ?", params[:min_price])
    end

    if params[:max_price] && !params[:max_price].empty?
      properties = properties.where("price <= ?", params[:max_price])
    end

    if params[:min_area] && !params[:min_area].empty?
      properties = properties.where("area >= ?", params[:min_area])
    end

    if params[:max_area] && !params[:max_area].empty?
      properties = properties.where("area <= ?", params[:max_area])
    end

    if params[:bedrooms] && !params[:bedrooms].empty?
      properties = properties.where("bedrooms >= ?", params[:bedrooms])
    end

    if params[:bathrooms] && !params[:bathrooms].empty?
      properties = properties.where("bedrooms >= ?", params[:bathrooms])
    end

    properties
  end
end