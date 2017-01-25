module Utility

  def formatit(input)
    value = input
    if input.class == Float
      value = sprintf('%2.2f', input)
    end
    value
  end

  def nutrient_per_measure(nutrient_name, ndbno, measure, q)
    quantity = q.to_f
    value = NOT_AVAILABLE
    response = Usda.caching_find(ndbno)
    unless response.nil?
      value = parse_response(value, response, measure, nutrient_name)
    end
    value *= quantity if value != NOT_AVAILABLE
    value
  end

  def parse_response(value, response, measure, nutrient_name)
    allnutrients = response['nutrients']
    nutrient = allnutrients.select { |n| n['name'] == nutrient_name }[0]
    unless nutrient.nil?
      value = parse_nutrients(measure, nutrient, value)
    end
    value
  end

  def parse_nutrients(measure, nutrient, value)
    if measure == 'g'
      value = handle_default_measure(nutrient)
    else
      value = compute_gram_equivelent(nutrient, measure, value)
    end
    value
  end

  def compute_gram_equivelent(nutrient, measure, value )
    allmeasures = nutrient['measures']
    if measure.size > 0
      hash = allmeasures.select { |m| m['label'] == measure }[0]
    else
      hash = allmeasures.first
    end
    unless hash.nil?
      value = compute_value_over_quantity(hash)
    end
    value
  end

  def handle_default_measure(nutrient)
    value = nutrient['value'].to_f
    value /= 100.0
  end

  def compute_value_over_quantity(hash)
    value = hash['value'].to_f
    qty = hash['qty'].to_f
    if qty
      value = value / qty
    end
    value
  end

end
