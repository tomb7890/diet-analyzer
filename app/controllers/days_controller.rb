class DaysController < ApplicationController

  include ApplicationHelper

  def index
    @day = Day.last
    redirect_to day_path(@day)
  end

  def create
    redirect_to day_path(@day)
  end

  def show
    if get_current_user.days.where(id: params[:id]).count > 0
      @day = Day.find(params[:id])
      @foods = @day.foods
    else
      redirect_to days_path
    end
  end
end
