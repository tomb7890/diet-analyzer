class Food < ActiveRecord::Base

  def calories
    nutrient('Energy')
  end

  def nutrient(arg)
    response = Usda.find(ndbno)
    allnutrients = response['nutrients']
    energy = allnutrients.select { |n| n['name'] == arg }[0]
    allmeasures = energy['measures']
    hash = allmeasures.select { |m| m['label'] == measure }[0]
    value = hash['value'].to_f
  end

  def name
    response = Usda.find(ndbno)
    name = response['name']
  end
end
