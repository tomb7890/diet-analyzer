require 'test_helper'

class UtilityTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  include Utility
  include Nutrients
  include Goals

  STRAWBERRIES_NDBNO = '09316'.freeze
  TURKEY_NDBNO = '05200'.freeze
  BOGUS_NDBNO = 818_181_818_181_818
  FIREWEED_LOCAL_RAW_HONEY = 45_104_569

  BIGMAC_NDBNO = '21350'.freeze
  POTATO_RUSSET_NDBNO = '11674'.freeze

  test 'test nutrient  method on food with bogus nutrient ' do
    day = create(:day_with_food)
    food = day.foods.first
    d = food.nutrient(0o101010101)
    assert_equal d, NOT_AVAILABLE
  end

  test 'correctly handle bogus nutrient on valid food' do
    result = nutrient_per_serving('Kryptonite', STRAWBERRIES_NDBNO, 'g', 1.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle bogus food and valid nutrient ' do
    result = nutrient_per_serving(CHOLE, BOGUS_NDBNO, 'g', 1.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle bogus measure' do
    result = nutrient_per_serving(ENERC_KCAL, STRAWBERRIES_NDBNO, 'foobar', 3.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle bogus nutrient, bogus food, and valid measure ' do
    result = nutrient_per_serving('Kryptonite', BOGUS_NDBNO, 'g', 3.0)
    assert_equal NOT_AVAILABLE, result
  end

  test 'correctly handle valid query' do
    result = nutrient_per_serving(CHOLE, STRAWBERRIES_NDBNO, 'g', 1.0)
    assert_equal 0.00, result
  end

  test 'nutrient_per_serving with known flawed record' do
    expected = 'N/A'
    actual = nutrient_per_serving(Nutrients::WATER,
                                  FIREWEED_LOCAL_RAW_HONEY,
                                  'g',
                                  1.0)
    assert_equal expected, actual
  end

  test 'correctly handle second valid query' do
    result = nutrient_per_serving(ENERC_KCAL, STRAWBERRIES_NDBNO,
                                  'cup, pureed', 1.0)
    assert_equal 74.0, result
  end

  test 'correctly handle grams Energy query' do
    # strawberries are 145 calories per pound
    expected = 145
    # One pound is 454 grams
    actual = nutrient_per_serving(ENERC_KCAL, STRAWBERRIES_NDBNO, 'g', 454)
    assert_in_delta actual, expected, 2
  end

  test 'correctly handle grams potassium query' do
    result = nutrient_per_serving(K, STRAWBERRIES_NDBNO, 'g', 453.6)
    assert_equal 694, result.to_i
  end

  test 'correctly handle nutrient qty attribute' do
    result = nutrient_per_serving(CHOLE, TURKEY_NDBNO, 'oz', 1)
    assert_equal 29, result.to_i
  end

  test 'determine eqv weight in grams of food serving ' do
    squash_winter_butternut_cooked_baked_without_salt = 11_486
    measure = 'cup, cubes'

    expected = 205
    actual = gram_equivalent(squash_winter_butternut_cooked_baked_without_salt,
                             measure)

    assert_equal expected, actual
  end

  test 'determine eqv weight in grams of potato' do
    potato_baked_russet = 11_356
    measure = "potato large (3\" to 4-1\/4\" dia."
    expected = 299
    actual = gram_equivalent(potato_baked_russet, measure)
    assert_equal expected, actual
  end

  test 'determine eqv weight in grams, varying qty parameters' do
    turkey = '05200'
    measure = 'oz'
    expected = 28
    actual = gram_equivalent(turkey, measure).to_i
    assert_equal expected, actual
  end

  test 'correct operation of gram_equivalent when measure is "g"' do
    measure = 'g'
    expected = 1.0
    actual = gram_equivalent(STRAWBERRIES_NDBNO, measure).to_i
    assert_equal expected, actual
  end

  test 'another test, varying qty parameters' do
    turkey = '05200'
    measure = 'turkey, bone removed'
    expected = 808 * 2
    actual = gram_equivalent(turkey, measure).to_i
    assert_equal expected, actual
  end

  test 'energy density of strawberries' do
    expected = 145
    actual = energy_density(STRAWBERRIES_NDBNO).to_i
    assert_equal expected, actual
  end

  test 'energy density of dry kasha is' do
    expected = 1569
    dry_kasha_ndbno = 20_009
    actual = energy_density(dry_kasha_ndbno).to_i
    assert_equal expected, actual
  end

  test 'correctly finds the general factor from a multi-ingredient food ' do
    expected = CALORIES_PER_GRAM_CARB
    actual = calories_per_gram(BIGMAC_NDBNO, 'cf', CALORIES_PER_GRAM_CARB)
    assert_equal expected, actual
  end

  test 'correctly finds the specific factor from a whole natural food' do
    expected = 2.78
    actual = calories_per_gram(POTATO_RUSSET_NDBNO, 'pf',
                               CALORIES_PER_GRAM_PROTEIN)
    assert_equal expected, actual
  end

  test 'gram_equivalent with junk as food ' do
    measure = 'turkey, bone removed'
    expected = NOT_AVAILABLE
    actual = gram_equivalent(BOGUS_NDBNO, measure)
    assert_equal expected, actual
  end

  test 'gram_equivalent with junk as measure ' do
    measure = 'foobar'
    expected = NOT_AVAILABLE
    actual = gram_equivalent(STRAWBERRIES_NDBNO, measure)
    assert_equal expected, actual
  end
end
