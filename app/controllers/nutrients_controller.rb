class NutrientsController < ApplicationController

  def show
    @foods = Day.find(params[:day_id]).foods
    @category= params[:id]
  end
end
