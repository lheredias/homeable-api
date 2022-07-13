class SavedsController < ApplicationController

  # GET /saved
  def index
    if current_user.user_type == "homeseeker"
      homeseeker = Homeseeker.where(user_id: current_user.id).first
      # properties = homeseeker.properties
      render json: homeseeker.saveds
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
        # property = Property.find(saved.property_id)
        render json: saved
      else
        render json: { errors: saved.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'user is not a homeseeker' }, status: :not_found       
    end
  end

  # PATCH/PUT /saveds/:id
  def update

    saved = Saved.find(params[:id])
    if !saved.nil?
      if current_user.user_type == "homeseeker"
        homeseeker = Homeseeker.find(saved.homeseeker_id)
        if homeseeker.user_id == current_user.id
          if saved.update(contacted: params[:contacted], favorite: params[:favorite])
            # property = Property.find(saved.property_id)
            render json: saved
          else
            render json: { errors: saved.errors }, status: :unprocessable_entity
          end
        else
          render json: { error: "incorrect saved property id" }, status: :not_found       
        end
  
      else
        render json: { error: 'user is not a homeseeker' }, status: :not_found       
      end
    else
      render json: { error: 'invalid saved property id' }, status: :not_found       
    end

  end

  # DELETE /saveds/:id
  def destroy
    saved = Saved.find(params[:id])
    if !saved.nil?
      if current_user.user_type == "homeseeker"
        homeseeker = Homeseeker.find(saved.homeseeker_id)
        if homeseeker.user_id == current_user.id
          saved.destroy
        else
          render json: { error: "incorrect saved property id" }, status: :not_found       
        end
      else
        render json: { error: 'user is not a homeseeker' }, status: :not_found       
      end
    else
      render json: { error: 'invalid saved property id' }, status: :not_found       
    end
  end

  private
  def saved_params
    params.require(:saved).permit(:contacted, :favorite, :property_id)
  end

end
