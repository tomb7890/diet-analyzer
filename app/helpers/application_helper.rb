module ApplicationHelper

  def measures_for_food(ndbno)
    response = Usda.caching_find(ndbno)
    array = response['nutrients'].first['measures'].map{|x| x['label']}
    array.insert(0, "g")
  end

  def caching_search(term)
    Rails.cache.fetch(term, expires_in: 28.days) do
      response = Usda.search(term)
    end
  end

  def nutrient_per_measure(arg, ndbno, measure)
    value  = "N/A"
    response = Usda.caching_find(ndbno)
    if not response.nil?
      allnutrients = response['nutrients']
      nutrient = allnutrients.select { |n| n['name'] == arg }[0]
      unless nutrient.nil?
        if measure == "g"
          value = nutrient['value'].to_f
          value /= 100.0
        else
          allmeasures = nutrient['measures']
          if measure.size > 0
            hash = allmeasures.select { |m| m['label'] == measure }[0]
          else
            hash = allmeasures.first
          end
          value = hash['value'].to_f
        end
      end
    end
    value
  end

  def nutrients_for_new_food_panel(ndbno, measure = "g")
    hash = {}

    hash['Energy'] = nutrient_per_measure('Energy', ndbno, measure)
    hash['Water'] = nutrient_per_measure('Water', ndbno, measure)
    hash['Carbs'] = nutrient_per_measure('Carbohydrate, by difference', ndbno, measure)

    hash['Fiber'] = nutrient_per_measure("Fiber, total dietary", ndbno, measure)
    hash['Protein'] = nutrient_per_measure('Protein', ndbno, measure)
    hash['Fat'] =   nutrient_per_measure('Total lipid (fat)', ndbno, measure)
    hash
  end

  def list_for_select_options(hashes)
    array = []
    if hashes
      hashes.each do |h|
        array_element = []
        array_element << h['name']
        array_element << h['ndbno']
        array << array_element
      end
    end
    array
  end
end
