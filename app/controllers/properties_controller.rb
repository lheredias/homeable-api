class PropertiesController < ApplicationController
  skip_before_action :require_login!, only: %i[index show]
  # GET /properties
  include PropertiesHelper
  def index
    # Get properties in order
    properties = Property.order(:updated_at)
  
    # Apply filters
    properties = query_filter(properties)

    # Get results counter
    count = properties.count

    # Apply pagination
    properties = properties.page params[:page] 

    # Extract useful values from pagination
    current = properties.page(params[:page]).current_page
    total = properties.page(params[:page]).total_pages
    limit = properties.page(params[:page]).limit_value
    output = {
      info: {
        count: count,
        current: properties.page(params[:page]).current_page,
        previous: (current > 1 ? (current - 1) : nil),
        next: (current >= total ? nil : (current + 1)),
        items_per_page: limit,
        pages: total
      },
      results: properties
    }
    render json: output
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

  private

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:operation, :address, :price, :maintenance,
        :property_type, :bedrooms, :latitude, :longitude, :bathrooms, :area, :pets, :about, :active)
    end

end
