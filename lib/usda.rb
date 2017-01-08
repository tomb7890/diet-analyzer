# The Usda class is Ruby interface to the USDA's nutrition API.

class Usda
  include HTTParty

  base_uri 'api.nal.usda.gov'

  def self.api_key
    UsdaParty.config.api_key
  end

  def self.measures_for_food(ndbno)
    response = self.caching_find(ndbno)
    response['nutrients'].first['measures'].map{|x| x['label']}
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

  def self.nutrient(arg, ndbno)
    value  = "N/A"
    response = self.caching_find(ndbno)
    if not response.nil?
      allnutrients = response['nutrients']
      nutrient = allnutrients.select { |n| n['name'] == arg }[0]

      unless nutrient.nil?
        value = nutrient['value'].to_f
      end

    end
    value
  end

  def self.nutrients_for_new_food_panel(ndbno)
    hash = {}

    hash['Energy'] = nutrient('Energy', ndbno)
    hash['Water'] = nutrient('Water', ndbno)
    hash['Carbs'] = nutrient('Carbohydrate, by difference', ndbno)

    hash['Fiber'] = nutrient("Fiber, total dietary", ndbno)
    hash['Protein'] = nutrient('Protein', ndbno)
    hash['Fat'] =   nutrient('Total lipid (fat)', ndbno)
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
