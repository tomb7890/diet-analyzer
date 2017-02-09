module Utility
  NOT_AVAILABLE = 'N/A'

  def formatit(input)
    value = input
    if input.class == Float
      value = sprintf('%2.2f', input)
    end
    value
  end

  def energy_density(ndbno)
    pounds_per_kilogram = 2.205
    nutrient_name = Nutrients::ENERC_KCAL
    measure = 'g'
    q = '1.0'.to_f
    value = nutrient_per_measure(nutrient_name, ndbno, measure, q)
    value = 1000.0 * value.to_f / pounds_per_kilogram
  end

  def gram_equivelent(ndbno, measure)
    eqv = 0
    response = Usda.caching_find(ndbno)
    unless response.nil?
      eqv = parse_response_2(response, measure)
    end
    eqv.to_f
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

  def parse_response_2(response, measure)
    allnutrients = response['nutrients']
    nutrient = allnutrients.first
    unless nutrient.nil?
      allmeasures = nutrient['measures']
      unless allmeasures.nil?
        hash = allmeasures.select { |m| m['label'] == measure }[0]
        eqv = compute_thing_over_quantity('eqv', hash)
      end
    end
    eqv
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

  def compute_gram_equivelent(nutrient, measure, value)
    allmeasures = nutrient['measures']
    if not measure.blank?
      hash = allmeasures.select { |m| m['label'] == measure }[0]
    else
      hash = allmeasures.first
    end
    unless hash.nil?
      value = compute_thing_over_quantity('value', hash)
    end
    value
  end

  def handle_default_measure(nutrient)
    value = nutrient['value'].to_f
    value /= 100.0
  end

  def compute_thing_over_quantity(thing, hash)
    if hash
      if hash.key? thing
        x  = hash[thing].to_f
        qty = hash['qty'].to_f
        if qty
          x = x / qty
        end
      end
      x
    end
  end

end
