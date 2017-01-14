class Food < ActiveRecord::Base

  include Utility

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

  def nutrient(nutrient_name)
    nutrient_per_measure(nutrient_name, ndbno, measure, amount )
  end

  def name
    name = nil
    response = caching_find(ndbno)
    if not response.nil?
      name = response['name']
    end
    name
  end

  def caching_find(ndbno)
    Rails.cache.fetch(ndbno, expires_in: 28.days) do
      response = Usda.find(ndbno)
    end
  end
end
