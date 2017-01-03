class Food < ActiveRecord::Base

  def calories
    nutrient('Energy')
  end

  def nutrient(arg)
    response = caching_find(ndbno)
    allnutrients = response['nutrients']
    energy = allnutrients.select { |n| n['name'] == arg }[0]
    allmeasures = energy['measures']
    hash = allmeasures.select { |m| m['label'] == measure }[0]
    value = hash['value'].to_f
  end

  def name
    response = caching_find(ndbno)
    name = response['name']
  end

  def caching_find(ndbno)
    Rails.cache.fetch(ndbno, expires_in: 28.days) do
      response = Usda.find(ndbno)
    end
  end
end
