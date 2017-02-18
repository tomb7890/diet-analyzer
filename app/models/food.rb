class Food < ActiveRecord::Base

  include Utility
  include ApplicationHelper

  def calories
    nutrient('Energy')
  end

  def nutrients_by_category(x)
    results = nil
    response = caching_find(ndbno)
    if not response.nil?
      nutrients = response['nutrients']
      results = nutrients.select {|hash|hash['group'] == x }
    end
  end

  def carb_energy
    factor = calories_per_gram(ndbno, 'cf', CALORIES_PER_GRAM_CARB)
    grams = total_nutrient_amount(Nutrients::CHOCDF)
    factor * grams
  end

  def fat_energy
    factor = calories_per_gram(ndbno, 'ff', CALORIES_PER_GRAM_FAT)
    grams = total_nutrient_amount(Nutrients::FAT)
    factor * grams
  end

  def protein_energy
    factor = calories_per_gram(ndbno, 'pf', CALORIES_PER_GRAM_PROTEIN)
    grams = total_nutrient_amount(Nutrients::PROCNT)
    factor * grams
  end

  def nutrient(nutrient_name)
    nutrient_per_measure(nutrient_name, ndbno, measure, amount )
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
