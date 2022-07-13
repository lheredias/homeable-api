class PropertiesController < ApplicationController
  skip_before_action :require_login!, only: %i[index show]
  # GET /properties
  def index
    properties = Property.all
    if params[:address]
      properties = properties.where("address ILIKE ?", "%"+ params[:address] +"%")
    end

    if params[:operation]
      properties = properties.where(operation:params[:operation].downcase())
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

    render json: properties
  end

  # GET /properties/1
  def show
    property = Property.find(params[:id])
    if property
      render json: property
    else
      render json: { error: 'not found' }, status: :not_found     
    end  
  end

  # POST /properties
  def create
    property = Property.new(property_params)
    if current_user.user_type == "landlord"
      landlord = Landlord.where(user_id: current_user.id).first
      property.landlord_id = landlord.id
      if property.save
        render json: property
      else
        render json: { errors: property.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'user is not a landlord' }, status: :not_found       
    end
  end

  # PATCH/PUT /properties/:id
  def update
    property = Property.find(params[:id])
    if !property.nil?
      if current_user.user_type == "landlord"
        landlord = Landlord.find(property.landlord_id)
        if landlord.user_id == current_user.id
          if property.update(property_params)
            render json: property
          else
            render json: { errors: property.errors }, status: :unprocessable_entity
          end
        else
          render json: { error: 'user is not the property landlord' }, status: :not_found       
        end

      else
        render json: { error: 'user is not a landlord' }, status: :not_found       
      end
    else
      render json: { error: 'invalid property id' }, status: :not_found       
    end

  end

  # DELETE /properties/:id
  def destroy
    property = Property.find(params[:id])
    if !property.nil?
      if current_user.user_type == "landlord"
        landlord = Landlord.find(property.landlord_id)
        if landlord.user_id == current_user.id
          property.destroy
        else
          render json: { error: 'user is not the property landlord' }, status: :not_found       
        end
      else
        render json: { error: 'user is not a landlord' }, status: :not_found       
      end
    else
      render json: { error: 'invalid property id' }, status: :not_found       
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:operation, :address, :price, 
        :property_type, :bedrooms, :bathrooms, :area, :pets, :about, :active)
    end

end
