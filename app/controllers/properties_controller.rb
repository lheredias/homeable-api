class PropertiesController < ApplicationController
  skip_before_action :require_login!, only: %i[index show]
  # GET /properties
  def index
    properties = Property.all

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

  # # PATCH/PUT /favorites/:id
  # def update
  #   if @favorite.update(favorite_params)
  #     render json: @favorite
  #   else
  #     render json: { errors: @favorite.errors }, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /favorites/:id
  # def destroy
  #   @favorite.destroy
  # end

  private

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:operation, :address, :price, 
        :property_type, :bedrooms, :bathrooms, :area, :pets, :about, :active)
    end

end
