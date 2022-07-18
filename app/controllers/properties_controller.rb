class PropertiesController < ApplicationController
  skip_before_action :require_login!, only: %i[index show list_addresses front_properties]
  # GET /properties
  include PropertiesHelper

  def index
    # Get properties in order
    uri = "https://homeable-api.herokuapp.com/properties/"
    properties = Property.order(updated_at: :desc)
    
    # List only active properties for filtering purposes
    properties = properties.where(active: true)
    # Apply filters
    properties = query_filter(properties)

    # Get results counter
    count = properties.count

    # Apply pagination
    properties = properties.page params[:page] 

    # Extract useful values from pagination
    current_page = properties.page(params[:page]).current_page
    pages = properties.page(params[:page]).total_pages
    items_per_page = properties.page(params[:page]).limit_value

    pagination = pagination(
      count, 
      current_page, 
      (current_page > 1) ? uri + (current_page - 1).to_s : nil, 
      current_page >= pages ? nil : uri + (current_page + 1).to_s, 
      items_per_page, 
      pages
    )
      
    render meta: pagination, adapter: :json, json: properties
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
      if !params[:property][:photo].nil?
        params[:property][:photo].each do |file|
          photo = Cloudinary::Uploader.upload(file)
          photo = Photo.create(url:photo['url'])
          property.photos << photo
          # photo = Photo.new(url:photo['url'])
          # photo.save
        end
      end
      # photo = Cloudinary::Uploader.upload(params[:property][:photo])
      # property.photo = photo['url']
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

  def list_addresses
    if params[:address] && !params[:address].empty?
      properties = Property.all
      addresses = properties.where("address ILIKE ?", "%"+ params[:address] + "%").pluck(:address)
      if addresses.empty?
        render json: addresses
      else
        render json: addresses.uniq
      end
    else
      head :no_content
    end
  end

  def front_properties
    properties = Property.order(updated_at: :desc)
    if params[:limit] && !params[:limit].empty?
      properties = properties.limit(params[:limit])
    else
      properties = properties.limit(3)
    end

    render json: properties

  end

   # GET /listed_properties
  def listed_properties
    if current_user.user_type == "landlord"
      landlord = Landlord.where(user_id: current_user.id).first
      properties  = landlord.properties
      render json: properties
    else
      render json: { error: 'user is not a landlord' }, status: :not_found       
    end
  end
  private

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:operation, :address, :price, :maintenance,
        :property_type, :bedrooms, :latitude, :longitude, :bathrooms, :area, :pets, :about, :active)
    end

end
