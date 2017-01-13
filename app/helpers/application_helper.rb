module ApplicationHelper

  def measures_for_food(ndbno)
    response = Usda.caching_find(ndbno)
    array = response['nutrients'].first['measures'].map{|x| x['label']}
    array.insert(0, 'g') unless array.include?('g')
    array
  end

  def caching_search(term)
    Rails.cache.fetch(term, expires_in: 28.days) do
      response = Usda.search(term)
    end
  end

  def nutrient_per_measure(arg, ndbno, measure, q)
    quantity = q.to_f
    value = 'N/A'
    response = Usda.caching_find(ndbno)
    unless response.nil?
      allnutrients = response['nutrients']
      nutrient = allnutrients.select { |n| n['name'] == arg }[0]
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
          value = hash['value'].to_f
        end
      end
    end
    value *= quantity if value != 'N/A'
    value
  end

  def nutrients_for_food_panel(ndbno, quantity, measure = "g")
    hash = {}

    hash['Energy'] = nutrient_per_measure('Energy', ndbno, measure, quantity)
    hash['Water'] = nutrient_per_measure('Water', ndbno, measure, quantity)
    hash['Carbs'] = nutrient_per_measure('Carbohydrate, by difference', ndbno,
                                         measure, quantity)
    hash['Fiber'] = nutrient_per_measure('Fiber, total dietary', ndbno,
                                         measure, quantity)
    hash['Protein'] = nutrient_per_measure('Protein', ndbno, measure, quantity)
    hash['Fat'] =   nutrient_per_measure('Total lipid (fat)', ndbno, measure,
                                         quantity)
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
