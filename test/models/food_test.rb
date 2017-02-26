require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test 'exercising the name method ' do
    f = foods(:soymilk)
    assert f.name == 'SILK Plain, soymilk'
  end

  test 'exercise the calories method' do
    g = foods(:blueberries)
    actual = g.calories
    expected = 84.36
    assert_in_delta actual, expected, 2
  end

  # Another test of the calories method
  test 'second exercise of the calories method' do
    g = foods(:raisinbran)
    actual = g.calories
    expected = 191
    assert_in_delta actual, expected, 2
  end

  test 'computation of proportion of fat energy in blueberries ' do
    f = foods(:blueberries)
    fe = f.fat_energy
    tt = f.calories
    actual = (100.0 * fe / tt)
    expected = 5
    assert_in_delta expected, actual, 1
  end

  test 'computation of proportion of total fat energy in diet' do
    ef = energy_from_fat
    tt = total_energy
    expected = 13
    actual = (100 * ef / tt)
    assert_in_delta expected, actual, 1
  end

  test 'dietary fat goal when calories == 0 ' do
    energy_from_fat = 0.0
    total_energy = 0.0
    actual = goal_dietaryfat_helper(energy_from_fat, total_energy)
    expected = true
    assert_equal expected, actual
  end

  test 'dietary fat goal when criteria just met' do
    total_energy = 2000.0
    energy_from_fat = (total_energy * 0.30 ) - 1
    actual = goal_dietaryfat_helper(energy_from_fat, total_energy)
    expected = true
    assert_equal expected, actual
  end

  test 'dietary fat goal when criteria just failed' do
    total_energy = 2000.0
    energy_from_fat = (total_energy * 0.30 ) + 1
    actual = goal_dietaryfat_helper(energy_from_fat, total_energy)
    expected = false
    assert_equal expected, actual
  end

  test 'nominal operation of dietary goals' do
    goal_dietaryfat
    goal_transfat
    goal_satfat
  end

  test 'computation of total fruit_and_veg' do
    amount = fruit_and_veg_goal(Food.all)
    assert_equal 148, amount
  end

  test 'satfat goal when calories are zero' do
    energy_from_sat_fat = 0.0
    total_energy = 0.0
    actual = goal_satfat_helper(energy_from_sat_fat, total_energy)
    expected = true
    assert_equal expected, actual
  end

  test 'transfat goal when calories are nonzero' do
    total_energy = 2000
    energy_from_trans_fat = 1.0
    actual = goal_transfat_helper(energy_from_trans_fat, total_energy)
    expected = false
    assert_equal expected, actual
  end

  test 'transfat goal when calories are zero' do
    total_energy = 0.0
    energy_from_trans_fat = 0.0
    actual = goal_transfat_helper(energy_from_trans_fat, total_energy)
    expected = true
    assert_equal expected, actual
  end
end
