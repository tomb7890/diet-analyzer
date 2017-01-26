require 'test_helper'

class UtilityTest < ActiveSupport::TestCase

  include Utility
  include Nutrients

  STRAWBERRIES_NDBNO = '09316'
  TURKEY_NDBNO = "05200"
  BOGUS_NDBNO = 818181818181818

  test 'correctly handle bogus nutrient on valid food' do
    result = nutrient_per_measure('Kryptonite', STRAWBERRIES_NDBNO, 'g', 1.0)
    assert NOT_AVAILABLE == result
  end

  test 'correctly handle bogus food and valid food ' do
    result = nutrient_per_measure(CHOLE, BOGUS_NDBNO, 'g', 1.0)
    assert NOT_AVAILABLE == result
  end

  test 'correctly handle bogus measure' do
    result = nutrient_per_measure(ENERC_KCAL, STRAWBERRIES_NDBNO, 'foobar', 3.0)
    assert NOT_AVAILABLE == result
  end

  test 'correctly handle valid query' do
    result = nutrient_per_measure(CHOLE, STRAWBERRIES_NDBNO, 'g', 1.0)
    assert 0.00 == result
  end

  test 'correctly handle second valid query' do
    result = nutrient_per_measure(ENERC_KCAL, STRAWBERRIES_NDBNO,
                                  'cup, pureed', 1.0)
    assert 74.0 == result
  end

  test 'correctly handle grams Energy query' do
    result = nutrient_per_measure(ENERC_KCAL, STRAWBERRIES_NDBNO, 'g', 453.6)
    assert 145 == result.to_i
  end

  test 'correctly handle grams potassium query' do
    result = nutrient_per_measure(K, STRAWBERRIES_NDBNO, 'g', 453.6)
    assert 694 == result.to_i
  end

  test 'correctly handle nutrient qty attribute' do
    result = nutrient_per_measure(CHOLE, TURKEY_NDBNO, "oz", 1)
    assert 29 == result.to_i
  end
end
