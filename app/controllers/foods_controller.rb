class FoodsController < ApplicationController

  def index
    @foods = Food.all
  end

  def new
    if params[:search]
      @items = Usda.search(params[:search])
    end
  end

  def show
    @food = Food.find(params[:id])
  end
end
