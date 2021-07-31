class Fdcapi
  include HTTParty
  base_uri 'https://api.nal.usda.gov'
  default_params :api_key => ENV['USDA_FDC_API_KEY']
  
  # Food Search endpoint returns foods that match desired search
  # criteria. The returned list is essentially a list of 
  # identifiers that are unique to each food.
  def self.search(searchterm)
    list = nil
    path = '/fdc/v1/search' 

    response = post(path,{
                      headers: {"Content-Type" => "application/json" }, 
                      body:    { 'generalSearchInput' => searchterm } .to_json
                    }
                   )
    if response
      list = response['foods']
    end
    list 
  end

  # Food Details endpoint returns details on a particular food. 
  def self.find(fdcid)
    food = nil
    response = get("/fdc/v1/#{fdcid}" , 
                   headers: {"Content-Type" => "application/json" }
                  )

    unless response.body.nil? || response.body.empty?
      food = response
    end
  end

  # A caching version of the above. Government data on food and
  # nutrition does not change very often, and so the use of a cache is
  # used to optimise performance.
  def self.caching_find(fdcid)
    Rails.cache.fetch(fdcid, expires_in: 28.days) do
      response = Fdcapi.find(fdcid)
    end
  end

  # The amount of a nutrient in a given food is for 100 grams of that
  # food. This method normalizes the nutrient amount per gram of food. 
  def self.handle_default_measure(nutrient_object)
    value = nutrient_object['amount']
    value / 100.0 if value.is_a? Float
  end

  def self.measures(fdcid)
    # Given a food's unique identifier, return a list of strings that
    # represent common terms used to describe portion sizes for a
    # particular food.  For example, raw mango may have among its
    # list of measures such terms as 'slice', 'mango', and 'cup'.
    response = Fdcapi.caching_find(fdcid)

    array = []

    if response['dataType'] == 'SR Legacy'
      array = response['foodPortions'].map {|x| x['modifier'] }

    elsif response['dataType'] == 'Survey (FNDDS)'
      array = response['foodPortions'].map {|x| x['portionDescription'] }

    elsif response['dataType'] == 'Branded'
      array << response['householdServingFullText'] 

    elsif response['dataType'] == 'Foundation' 
      array = response['foodPortions'].map{|x| x['measureUnit']['name'] }
    end

    array 
  end

  def self.weight(response, measure_name)
    # Given a food (specified by response), and its measure name
    # (e.g. "slice" of mango) return the weight in grams of that portion of food. 
    value = nil

    if response['dataType'] == 'SR Legacy'
       measure_object = response['foodPortions'].detect{|p| p['modifier'] == measure_name}
       value = measure_object['gramWeight']
       value = value / measure_object['amount'] if measure_object.has_key? 'amount'

    elsif response['dataType'] == 'Survey (FNDDS)'
      measure_object = response['foodPortions'].detect{|p| p['portionDescription'] == measure_name}
      value = measure_object['gramWeight']
      value = value / measure_object['amount'] if measure_object.has_key? 'amount'

    elsif response['dataType'] == 'Branded'
      value = response['servingSize']

    elsif response['dataType'] == 'Foundation'
      measure_object= response['foodPortions'].find{|x| x['measureUnit']['name'] == measure_name}
      value = measure_object['gramWeight']
      value = value / measure_object['amount'] if measure_object.has_key? 'amount'
    end
    
    value 
  end


  
end



