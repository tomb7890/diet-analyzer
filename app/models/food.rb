class Food < ActiveRecord::Base

  belongs_to :day

  include Utility
  include ApplicationHelper

  def calories
    nutrient(ENERC_KCAL)
  end

  def nutrients_by_category(x)
    results = nil
    response = Usda.caching_find(ndbno)
    if not response.nil?
      nutrients = response['nutrients']
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
    factor = calories_per_gram(ndbno, tag, standard_conversion_factor)
    grams = nutrient_per_serving(nutrient,  ndbno, measure, amount)
    factor * grams
  end

  def nutrient(nutrient_name)
    nutrient_per_serving(nutrient_name, ndbno, measure, amount )
  end

  def name
    name = nil
    response = Usda.caching_find(ndbno)
    if not response.nil?
      name = response['name']
    end
    name
  end

end
