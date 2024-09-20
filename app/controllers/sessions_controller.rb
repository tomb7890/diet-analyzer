class SessionsController < ApplicationController

  skip_before_action :authenticate_user!, except: [:destroy]

  def index
    redirect_to login_url
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => "Logged in!"
      session[:current_user_date] = DateTime.now.to_date.to_s  # user.id
    else
      flash.now.alert = "Email or password was invalid"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end

end
