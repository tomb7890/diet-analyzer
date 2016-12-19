class Food < ActiveRecord::Base

  def calories
    ndbno_x = ndbno.to_s.rjust(5, '0')
    response = Usda.find(ndbno_x)
    allnutrients = response['nutrients']
    energy = allnutrients.select { |n| n['name'] == 'Energy' }[0]
    allmeasures = energy['measures']
    m = allmeasures.select {|m| m["label"] == measure  }[0]
    value = m["value"].to_f
    puts value
    value
  end

  def name
    ndbno_x = ndbno.to_s.rjust(5, '0')
    response = Usda.find(ndbno_x)
    name = response["name"]
  end
end
