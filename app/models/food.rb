class Food < ActiveRecord::Base

  def calories
    ndbno_x = ndbno.to_s.rjust(5, '0')
    response = Usda.find(ndbno_x)
    allnutrients = response['nutrients']
    energy = allnutrients.select { |n| n['name'] == 'Energy' }[0]
    allmeasures = energy['measures']
    measure = allmeasures.select {|m| m["label"] == "cup" }[0]
    value = measure["value"].to_f
    value
  end
end
