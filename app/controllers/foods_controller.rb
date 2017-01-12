class FoodsController < ApplicationController

  include ApplicationHelper

  def index
    @foods = Food.all
  end

  def new
    @food = Food.new
    if params[:search]
      @items = caching_search(params[:search])
      @items = list_for_select_options(@items)
    end
  end

  def show
    @food = Food.find(params[:id])
  end

  def create
    @food = Food.create(food_params)
    if @food.save
      redirect_to foods_url
    else
      render :new
    end
  end

  def edit
    @food = Food.find(params[:id])
    @measures = measures_for_food(@food.ndbno)
    @nutrients = nutrients_for_new_food_panel(@food.ndbno, @food.amount, @food.measure )
  end

  def update_measures
    ndbno = params[:ndbno]
    @measures = measures_for_food(ndbno)
    quantity = 1.0
    @nutrients = nutrients_for_new_food_panel(ndbno, quantity)
    respond_to do |format|
      format.json { render json: { measures: @measures, nutrients: @nutrients }}
    end
  end

  def update_nutrients
    ndbno = params[:ndbno]
    measure = params[:measure]

    quantity = 1.0

    if params[:quantity]
      quantity = params[:quantity]
    end

    @nutrients = nutrients_for_new_food_panel(ndbno, quantity, measure)
    respond_to do |format|
      format.json { render json: { nutrients: @nutrients }}
    end
  end

  private

  def food_params
    params.require(:food).permit(:ndbno, :amount, :measure)
  end
end
