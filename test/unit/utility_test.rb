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

  test 'determine eqv weight in grams of food serving ' do
    squash_winter_butternut_cooked_baked_without_salt = 11486
    measure = "cup, cubes"

    expected = 205
    actual =gram_equivelent(squash_winter_butternut_cooked_baked_without_salt,
                            measure)

    assert expected == actual
  end

  test 'determine eqv weight in grams of potato' do
    potato_baked_russet = 11356
    measure = "potato large (3\" to 4-1\/4\" dia."
    expected = 299
    actual = gram_equivelent(potato_baked_russet, measure)
    assert expected == actual
  end

  test 'determine eqv weight in grams, varying qty parameters' do
    turkey = '05200'
    measure = 'oz'
    expected = 28
    actual = gram_equivelent(turkey, measure).to_i
    assert expected == actual
  end

  test 'another test, varying qty parameters' do
    turkey = '05200'
    measure = 'turkey, bone removed'
    expected = 808*2
    actual = gram_equivelent(turkey, measure).to_i
    assert expected == actual
  end

end
