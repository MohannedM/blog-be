module Api
	module V1
		class UsersController < ApplicationController

       before_action :authorized, only: [:auto_login]

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token} , status: :created
    else
      render json: {error: "Invalid email or password"} , status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token} , status: :ok
    else
      render json: {error: "Invalid email or password"} , status: :unprocessable_entity
    end
  end


  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:email, :password, :image_path, :name)
  end


    end
	end
end