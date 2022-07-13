class UsersController < ApplicationController
  skip_before_action :require_login!, only: :create
  # GET /profile
  def show
    render json: current_user
  end

  # POST /signup
  def create
    user = User.new(user_params)
    
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profile
  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  # GET /users/1/properties
  def properties
    if current_user.user_type == "landlord"
      landlord = Landlord.where(user_id: current_user.id).first
      properties  = landlord.properties
    else
      homeseeker = Homeseeker.where(user_id: current_user.id).first
      properties  = homeseeker.properties
    end

    render json: properties
  end

  # DELETE /profile
  delegate :destroy, to: :current_user

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:email, :password, :name, :phone, :user_type)
  end
end