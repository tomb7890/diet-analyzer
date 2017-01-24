require 'test_helper'

class UtilityTest < ActiveSupport::TestCase

  include Utility

  STRAWBERRIES_NDBNO = '09316'
  BOGUS_NDBNO = 818181818181818

  test 'correctly handle bogus nutrient on valid food' do
    result = nutrient_per_measure('Kryptonite', STRAWBERRIES_NDBNO, 'g', 1.0)
    assert 'N/A' == result
  end

  test 'correctly handle bogus food and valid food ' do
    result = nutrient_per_measure('Cholesterol', BOGUS_NDBNO, 'g', 1.0)
    assert 'N/A' == result
  end

  test 'correctly handle bogus measure' do
    result = nutrient_per_measure('Cholesterol', STRAWBERRIES_NDBNO, 'g', 1.0)
    assert 0.00 == result
  end

end
