class PropertiesController < ApplicationController
  skip_before_action :require_login!, only: %i[index show]
  # GET /properties
  include PropertiesHelper
  def index
    properties = Property.order(:updated_at).page params[:page]
    # properties = Property.all
    # if params[:limit].empty?
    #   params[:limit] = 1
    # end
    # properties = Property.limit(params[:limit]).offset(params[:offset])

    properties = query_filter(properties)

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
        :property_type, :bedrooms, :bathrooms, :area, :pets, :about, :active)
    end

end
