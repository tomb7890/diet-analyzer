require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test "correct computation of calories of blueberries" do
    g = foods(:blueberries)
    assert g.calories.round(0) == 84.36.round(0)
  end
end
