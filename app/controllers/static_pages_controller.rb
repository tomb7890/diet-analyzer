class StaticPagesController < ApplicationController

  skip_before_action :authenticate_user!

  def about
  end
end
