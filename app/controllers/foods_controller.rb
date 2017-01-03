class FoodsController < ApplicationController

  def index
    if params[:search]
      @foods = Usda.search(params[:search])
    else
      @foods = Food.all
    end
  end

  def show
    @food = Food.find(params[:id])
  end
end
