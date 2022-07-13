class SavedsController < ApplicationController

  # GET /saved
  def index
    if current_user.user_type == "homeseeker"
      homeseeker = Homeseeker.where(user_id: current_user.id).first
      properties = homeseeker.properties
      render json: properties
    else
      render json: { error: 'user is not a homeseeker' }, status: :not_found       
    end
  end

  # POST /saved
  def create
    if current_user.user_type == "homeseeker"
      saved = Saved.new(saved_params)
      homeseeker = Homeseeker.where(user_id: current_user.id).first
      saved.homeseeker_id = homeseeker.id
      if saved.save
        property = Property.find(saved.property_id)
        render json: property
      else
        render json: { errors: saved.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'user is not a homeseeker' }, status: :not_found       
    end
  end

  private
  def saved_params
    params.require(:saved).permit(:contacted, :favorite, :property_id)
  end

end
