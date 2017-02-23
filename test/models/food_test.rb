require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test 'correct operation of name method ' do
    f = foods(:soymilk)
    assert f.name == 'SILK Plain, soymilk'
  end

  test 'correct computation of calories of blueberries' do
    g = foods(:blueberries)
    assert_equal g.calories.round(0), 84.36.round(0)
  end

  test 'correct computation of calories of given food sample' do
    g = foods(:raisinbran)
    assert_equal g.calories, 191
  end

  end

end
