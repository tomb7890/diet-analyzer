class FoodsController < ApplicationController

  include ApplicationHelper

  def new
    @food = Food.new
    if params[:search]
      @items = caching_search(params[:search])
      @items = list_for_select_options(@items)
    end
    @day = current_user.days.where(id: params[:day_id]).first
  end

  def show
    @food = Food.find(params[:id])
  end

  def create
    day_id = params[:day_id]
    @day = Day.find(day_id)
    @food = @day.foods.build(food_params)

    if @food.save
      redirect_to day_path(@day)
    else
      render :new
    end
  end

  def edit
    food_id = params[:id]
    @food = Food.find(food_id)
    day_id = params[:day_id]
    @day = Day.find(day_id)
  end

  def update
    @day = Day.find(params[:day_id])
    @food = Food.find(params[:id])

    if @food.update_attributes(food_params)
      redirect_to day_path(@day)
    else
      render :edit
    end
  end

  def update_measures
    if params[:id]
      @measures = measures_for_food(params[:fdcid])

      current_food = Food.find(params[:id])
      @nutrients = nutrients_for_food_panel(current_food.fdcid,
                                            current_food.amount,
                                            current_food.measure,
                                           )
      respond_to do |format|
        format.json { render json: { measures: @measures, nutrients: @nutrients,
                                     selected_measure: current_food.measure }}
      end
    else # called upon change in food selection
      fdcid = params[:fdcid]
      @measures = measures_for_food(fdcid)
      amount = 1.0
      @nutrients = nutrients_for_food_panel(fdcid, amount)
      respond_to do |format|
        format.json { render json: { measures: @measures, nutrients: @nutrients }}
      end
    end
  end

  def destroy
    @day = Day.find(params[:day_id])
    @food = Food.find(params[:id])
    @food.destroy
    redirect_to day_path(@day)
  end

  def update_nutrients
    
    fdcid = params[:fdcid]
    measure = params[:measure]
    amount = 1.0

    if params[:amount]
      amount = params[:amount]
    end

    @nutrients = nutrients_for_food_panel(fdcid, amount, measure)
    respond_to do |format|
      format.json { render json: { nutrients: @nutrients }}
    end
  end

  private

  def food_params
    params.require(:food).permit(:fdcid, :amount, :measure).merge(user_id: current_user.id)
  end
end
