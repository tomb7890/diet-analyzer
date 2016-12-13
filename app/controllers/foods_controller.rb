class FoodsController < ApplicationController

  def index
    if params[:search]
      @foods = Food.search(params[:search])
    else
      @foods = Food.all
    end
  end

  def show
    @food = Food.find(params[:id])
  end
end
