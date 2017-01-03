class Food < ActiveRecord::Base

  def calories
    nutrient('Energy')
  end

  def nutrient(arg)
    value  = nil
    response = caching_find(ndbno)
    if not response.nil?
      allnutrients = response['nutrients']
      energy = allnutrients.select { |n| n['name'] == arg }[0]
      allmeasures = energy['measures']

      if measure.size > 0
        hash = allmeasures.select { |m| m['label'] == measure }[0]
      else
        hash = allmeasures.first
      end
      value = hash['value'].to_f
    end
    value
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
