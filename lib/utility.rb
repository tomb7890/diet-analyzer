module Utility
  NOT_AVAILABLE = 'N/A'

  def formatit(input)
    value = input
    if input.class == Float
      value = sprintf('%2.2f', input)
    end
    value
  end


  def specific_food_factor(ndbno, json_tag)
    factor = nil
    response = Usda.caching_find(ndbno)
    x = response[json_tag]
    if x
      factor = x
    end
    factor
  end

  def calories_per_gram(ndbno, json_tag, general_macronutrient_factor)
    factor = general_macronutrient_factor
    sf = specific_food_factor(ndbno, json_tag)
    if sf !=nil && sf.to_f > 0.0
      factor = sf
    end
    factor
  end

  def energy_density(ndbno)
    pounds_per_kilogram = 2.205
    nutrient_name = Nutrients::ENERC_KCAL
    measure = 'g'
    q = '1.0'.to_f
    value = nutrient_per_measure(nutrient_name, ndbno, measure, q)
    1000.0 * value.to_f / pounds_per_kilogram
  end

  def gram_equivelent(ndbno, measure)
    eqv = 0
    foodreport = Usda.caching_find(ndbno)
    unless foodreport.nil?
      measure_object = measure_object_from_food_report(foodreport, measure)
      eqv = element_from_measure_object('eqv', measure_object)
    end
    eqv.to_f
  end

  def nutrient_per_measure(nutrient_name, ndbno, measure, q)
    quantity = q.to_f
    value = NOT_AVAILABLE
    food_report = Usda.caching_find(ndbno)
    unless food_report.nil?
      value = process_food_report(value, food_report, measure, nutrient_name)
    end
    value *= quantity if value != NOT_AVAILABLE
    value
  end

  def measure_object_from_food_report(foodreport, measure)
    measure_object = nil
    allnutrients = foodreport['nutrients']
    nutrient = allnutrients.first
    unless nutrient.nil?
      allmeasures = nutrient['measures']
      unless allmeasures.nil?
        measure_object = allmeasures.select { |m| m['label'] == measure }[0]
      end
    end
    measure_object
  end

  def process_food_report(value, response, measure, nutrient_name)
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
      value = handle_specified_measure(nutrient, measure, value)
    end
    value
  end

  def handle_specified_measure(nutrient, measure, value)
    allmeasures = nutrient['measures']
    unless measure.blank?
      hash = allmeasures.select { |m| m['label'] == measure }[0]
    end
    unless hash.nil?
      value = element_from_measure_object('value', hash)
    end
    value
  end

  def handle_default_measure(nutrient)
    value = nutrient['value'].to_f
    value / 100.0
  end

  def element_from_measure_object(element, measure_object)
    if measure_object
      if measure_object.key? element
        x = measure_object[element].to_f
        qty = measure_object['qty'].to_f
        if qty
          x = x / qty
        end
      end
      x
    end
  end

end
