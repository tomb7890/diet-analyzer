# The Usda class is Ruby interface to the USDA's nutrition API.

class Usda
  include HTTParty

  base_uri 'api.nal.usda.gov'

  def self.api_key
    UsdaParty.config.api_key
  end

  def self.measures_for_food(ndbno)
    response = self.caching_find(ndbno)
    array = response['nutrients'].first['measures'].map{|x| x['label']}
    array.insert(0, "g")
  end

  def self.id_or_ndbno(hash)
    if hash.key?('ndbno')
      hash['ndbno']
    elsif hash.key?('id')
      hash['id']
    end
  end

  def self.subset(f, x)
    f['nutrients'].select {|hash|hash['group'] == x }
  end

  def self.all
    options = {
      'api_key' => api_key,
      'format' => 'json',
      'lt' => 'f',
      'sort' => 'n',
      'total' => '4',
      'offset' => '0'
    }
    get('/ndb/list',
        :query => options)['list']['item']
  end

  def self.find(food_id)
    food = nil
    food_id_rjust = food_id.to_s.rjust(5, '0')
    options = {
      'ndbno' => food_id_rjust,
      'type' => 'b',
      'format' => 'json',
      'api_key' => api_key
    }

    response = get('/ndb/reports/',
                   query: options)

    unless response.nil?
      report = response['report']
      unless report.nil?
        food = report['food']
      end
    end
    food
  end

  def self.caching_find(ndbno)
    Rails.cache.fetch(ndbno, expires_in: 28.days) do
      response = Usda.find(ndbno)
    end
  end

  def self.nutrient_per_measure(arg, ndbno, measure)
    value  = "N/A"
    response = self.caching_find(ndbno)
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

  def self.nutrients_for_new_food_panel(ndbno, measure = "g")
    hash = {}

    hash['Energy'] = nutrient_per_measure('Energy', ndbno, measure)
    hash['Water'] = nutrient_per_measure('Water', ndbno, measure)
    hash['Carbs'] = nutrient_per_measure('Carbohydrate, by difference', ndbno, measure)

    hash['Fiber'] = nutrient_per_measure("Fiber, total dietary", ndbno, measure)
    hash['Protein'] = nutrient_per_measure('Protein', ndbno, measure)
    hash['Fat'] =   nutrient_per_measure('Total lipid (fat)', ndbno, measure)
    hash
  end

  def self.search(string)
    item = nil

    options = {
      'format' => 'json',
      'q' => string,
      'api_key' => api_key
    }
    response = get('/ndb/search/',
                   query: options)

    unless response.nil?
      list = response['list']
      unless list.nil?
        item = list['item']
      end
    end
    item
  end
end
