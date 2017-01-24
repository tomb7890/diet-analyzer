module Utility
  def nutrient_per_measure(nutrient_name, ndbno, measure, q)
    quantity = q.to_f
    value = 'N/A'
    response = Usda.caching_find(ndbno)
    unless response.nil?
      allnutrients = response['nutrients']
      nutrient = allnutrients.select { |n| n['name'] == nutrient_name }[0]
      unless nutrient.nil?
        if measure == 'g'
          value = nutrient['value'].to_f
          value /= 100.0
        else
          allmeasures = nutrient['measures']
          if measure.size > 0
            hash = allmeasures.select { |m| m['label'] == measure }[0]
          else
            hash = allmeasures.first
          end
          unless hash.nil?
            value = hash['value'].to_f
          end
        end
      end
    end
    value *= quantity if value != 'N/A'
    value
  end
end
