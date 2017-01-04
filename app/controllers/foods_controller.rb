class FoodsController < ApplicationController

  include ApplicationHelper

  def index
    @foods = Food.all
  end

  def new
    if params[:search]
      @items = caching_search(params[:search])
      @items = list_for_select_options (@items)
    end
  end

  def show
    @food = Food.find(params[:id])
  end

  def caching_search(term)
    Rails.cache.fetch(term, expires_in: 28.days) do
      response = Usda.search(term)
    end
  end

end
