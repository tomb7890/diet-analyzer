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
    if response
      x = response[json_tag]
      if x
        factor = x
      end
    end
    factor
  end

  def calories_per_gram(ndbno, json_tag, standard_conversion_factor)
    factor = standard_conversion_factor
    sff = specific_food_factor(ndbno, json_tag)
    if sff !=nil && sff.to_f > 0.0
      factor = sff
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

  def gram_equivelent_with_specified_measure(ndbno, measure)
    eqv = NOT_AVAILABLE
    begin
      foodreport = Usda.caching_find(ndbno)
      measure_object = measure_object_from_food_report(foodreport, measure)
      eqv = element_from_measure_object('eqv', measure_object)
      eqv = eqv.to_f
    rescue NoMethodError => e
      Rails.logger.error "gram_equivelent_with_specified_measure ( #{ndbno}, #{measure}); #{e.class.name} : #{e.message}"
    end
    eqv
  end

  def gram_equivelent(ndbno, measure)
    if measure == 'g'
      eqv = 1.0
    else
      eqv = gram_equivelent_with_specified_measure(ndbno, measure)
    end
    eqv
  end

  def nutrient_per_measure(nutrient_name, ndbno, measure, q)
    quantity = q.to_f
    value = NOT_AVAILABLE
    begin
      food_report = Usda.caching_find(ndbno)
      value = process_food_report(value, food_report, measure, nutrient_name)
      value *= quantity
    rescue NoMethodError => e
      Rails.logger.error "nutrient_per_measure(#{nutrient_name}, #{ndbno}, #{measure}); #{e.class.name} : #{e.message}"
    end
    value
  end

  def measure_object_from_food_report(foodreport, measure)
    allnutrients = foodreport['nutrients']
    nutrient = allnutrients.first
    allmeasures = nutrient['measures']
    measure_object = allmeasures.select { |m| m['label'] == measure }[0]
    measure_object
  end

  def process_food_report(value, response, measure, nutrient_name)
    allnutrients = response['nutrients']
    nutrient = allnutrients.select { |n| n['name'] == nutrient_name }[0]
    value = parse_nutrients(measure, nutrient, value)
    value
  end

  def parse_nutrients(measure, nutrient, value)
    value = 0
    if measure == 'g'
      value = handle_default_measure(nutrient)
    else
      value = handle_specified_measure(nutrient, measure, value)
    end
    value
  end

  def handle_specified_measure(nutrient, measure, value)
    allmeasures = nutrient['measures']
    hash = allmeasures.select { |m| m['label'] == measure }[0]
    value = element_from_measure_object('value', hash)
    value
  end

  def handle_default_measure(nutrient)
    value = nutrient['value'].to_f
    value / 100.0
  end

  def element_from_measure_object(element, measure_object)
    if measure_object.key? element
      x = measure_object[element].to_f
      qty = measure_object['qty'].to_f
      if qty
        if qty > 0
          x = x / qty
        end
      end
    end
    x
  end

end
