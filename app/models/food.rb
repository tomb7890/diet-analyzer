class Food < ActiveRecord::Base

  def calories
    response = Usda.find(ndbno)
    allnutrients = response['nutrients']
    energy = allnutrients.select { |n| n['name'] == 'Energy' }[0]
    allmeasures = energy['measures']
    m = allmeasures.select { |m| m["label"] == measure }[0]
    value = m["value"].to_f
    puts value
    value
  end

  def name
    response = Usda.find(ndbno)
    name = response["name"]
  end
end
