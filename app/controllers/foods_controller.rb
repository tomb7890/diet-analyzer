class FoodsController < ApplicationController

  include ApplicationHelper

  def index
    @foods = Food.order(:id).all
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
  end

  def update
    @food = Food.find(params[:id])

    if @food.update_attributes(food_params)
      redirect_to foods_url
    else
      render :edit
    end
  end

  def update_measures
    if params[:id]
      @measures = measures_for_food(params[:ndbno])

      current_food = Food.find(params[:id])

      @nutrients = nutrients_for_food_panel(current_food.ndbno,
                                            current_food.amount,
                                            current_food.measure,
                                           )
      respond_to do |format|
        format.json { render json: { measures: @measures, nutrients: @nutrients,
                                     selected_measure: current_food.measure }}
      end
    else # called upon change in food selection
      ndbno = params[:ndbno]
      @measures = measures_for_food(ndbno)
      amount = 1.0
      @nutrients = nutrients_for_food_panel(ndbno, amount)
      respond_to do |format|
        format.json { render json: { measures: @measures, nutrients: @nutrients }}
      end
    end
  end

  def update_nutrients
    ndbno = params[:ndbno]
    measure = params[:measure]
    amount = 1.0

    if params[:amount]
      amount = params[:amount]
    end

    @nutrients = nutrients_for_food_panel(ndbno, amount, measure)
    respond_to do |format|
      format.json { render json: { nutrients: @nutrients }}
    end
  end

  private

  def food_params
    params.require(:food).permit(:ndbno, :amount, :measure)
  end
end
