class UsersController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to edit_user_path(@user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :heightcm, :weightkg, :gender,
                                 :activitylevel,
                                 :dob)
  end

end
