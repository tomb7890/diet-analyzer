class DaysController < ApplicationController

  include ApplicationHelper

  def index
    today = DateTime.now.to_date
    @day = current_user.days.where(date: today).first
    if @day.nil?
      @day = current_user.days.create(date: today)
    end
    redirect_to day_path(@day)
  end

  def create
    datestring = params[:date].to_s
    @day = current_user.days.create(date: datestring)
    redirect_to day_path(@day)
  end

  def show
    if current_user.days.where(id: params[:id]).count > 0
      @day = Day.find(params[:id])
      @foods = @day.foods
    else
      redirect_to days_path
    end
  end

end
