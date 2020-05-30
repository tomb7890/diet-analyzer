module Utility

  NOT_AVAILABLE = 'N/A'

  # Called by application_helper for use in views. Floating point
  # calculations are often done which would otherwise lead to an
  # irregular user interface presentation.
  def formatit(input)
    value = input
    if input.class == Float
      value = sprintf('%2.2f', input)
    end
    value
  end

  # Return the energy density in calories per gram for a
  # food specified by its FDCID, or unique identifier.  Look
  # for a custom conversion factor. If none is found it will fall back
  # to the standard conversion factor.
  def calories_per_gram(fdcid, macronutrient_type, standard_conversion_factor)
    factor = standard_conversion_factor
    sff = specific_food_factor(fdcid, macronutrient_type)
    if sff !=nil && sff.to_f > 0.0
      factor = sff
    end
    factor
  end

  # Food reports will sometimes have calorie conversion factors that
  # relay how many calories per gram there are for the three different
  # macronutrient types:  "proteinValue","fatValue", or "carbohydrateValue."
  def specific_food_factor(fdcid, macronutrient_type)
    factor = nil
    response = Fdcapi.caching_find(fdcid)
    if response && response.has_key?('nutrientConversionFactors')
      calorieconversionfactor = response['nutrientConversionFactors'].detect{|x| x['type'] == '.CalorieConversionFactor' }
      unless calorieconversionfactor.blank?
        factor = calorieconversionfactor[macronutrient_type]
      end
    end
    factor
  end

  # Return the energy density of a food in calories per pound. 
  def energy_density(fdcid)
    pounds_per_kilogram = 2.205
    nutrient_name = Nutrients::ENERC_KCAL
    measure = 'g'
    q = '1.0'.to_f
    value = nutrient_per_serving(nutrient_name, fdcid, measure, q)
    1000.0 * value.to_f / pounds_per_kilogram
  end

  def gram_equivalent(fdcid, measure)
    if measure == 'g'
      eqv = 1.0
    else
      eqv = gram_equivalent_with_specified_measure(fdcid, measure)
    end
    eqv
  end

  def gram_equivalent_with_specified_measure(fdcid, measure)
    eqv = NOT_AVAILABLE
    begin
      food_report = Fdcapi.caching_find(fdcid)
      Fdcapi.weight(food_report, measure).nil? ? eqv = NOT_AVAILABLE  : eqv = Fdcapi.weight(food_report, measure)
    rescue NoMethodError => e
      Rails.logger.error "gram_equivalent_with_specified_measure ( #{fdcid}, #{measure}); #{e.class.name} : #{e.message}"
    end
    eqv
  end

  def nutrient_per_serving(nutrient_name, fdcid, measure_name, q)
    quantity = q.to_f
    value = NOT_AVAILABLE
    begin
      food_report = Fdcapi.caching_find(fdcid)
      value = nutrient_per_measure(food_report, measure_name, nutrient_name)
      value *= quantity
    rescue NoMethodError => e
      Rails.logger.error "nutrient_per_serving(#{nutrient_name}, #{fdcid}, #{measure_name}); #{e.class.name} : #{e.message}"
    end
    value
  end

  def nutrient_per_measure(food_report, measure_name, nutrient_name)
    nutrient_object = fetch_nutrient_object(food_report, nutrient_name)
    value = nutrient_value_from_nutrient_object(food_report, measure_name, nutrient_object)
    value
  end

  def fetch_nutrient_object(food_report, nutrient_name)
    allnutrients = food_report['foodNutrients']
    selection = allnutrients.detect { |n| n['nutrient']['name'] == nutrient_name } 
 end

  def nutrient_value_from_nutrient_object(food_report, measure_name, nutrient_object)
    value = 0

    grameequiveent = 1.0 
    if measure_name != 'g'

      # from food measure name, retrieve its weight of the food in grams. 
      grameequiveent  = Fdcapi.weight(food_report, measure_name)
    end

    Fdcapi.handle_default_measure(nutrient_object) * grameequiveent
  end

end
