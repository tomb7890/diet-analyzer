require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  # test 'correct long_desc retrieval from database' do
  #   f = foods(:soymilk)
  #   assert f.long_description == 'SILK Plain, soymilk'
  # end

  # test "correct msre_desc retrieval from database" do
  #   f = foods(:raisinbran)
  #   assert f.measurement_description == 'cup (1 NLEA serving)'
  # end

  # test "correct computation of calories of given food sample" do
  #   g = foods(:raisinbran)
  #   assert g.calories == 188.8
  # end

  test "correct computation of calories of blueberries" do
    g = foods(:blueberries)
    assert g.calories == 84.36
  end

  # test "correct computation of calories of food with out a MSRE_SEQ" do
  #   g = foods(:fireweed)
  #   assert g.calories.round(1) == 44.0
  # end


end
