class Food < ApplicationRecord

  belongs_to :day

  include Utility
  include ApplicationHelper

  def calories
    nutrient(ENERC_KCAL)
  end

  def nutrients_by_category(x)
    results = nil
    response = Fdcapi.caching_find(fdcid)
    if not response.nil?
      nutrients = response['foodNutrients']
      results = nutrients.select {|hash|hash['group'] == x }
    end
  end

  def carb_energy
    macro_energy('cf', CALORIES_PER_GRAM_CARB, CHOCDF)
  end

  def fat_energy
    macro_energy('ff', CALORIES_PER_GRAM_FAT, FAT)
  end

  def protein_energy
    macro_energy('pf', CALORIES_PER_GRAM_PROTEIN, PROCNT)
  end

  def macro_energy(tag, standard_conversion_factor, nutrient)
    factor = calories_per_gram(fdcid, tag, standard_conversion_factor)
    grams = nutrient_per_serving(nutrient,  fdcid, measure, amount)
    factor * grams
  end

  def nutrient(nutrient_name)
    nutrient_per_serving(nutrient_name, fdcid, measure, amount )
  end

  def name
    name = nil
    response = Fdcapi.caching_find(fdcid)
    if not response.body.nil? || response.body.empty?
      name = response['description']
    end
    name
  end

end
