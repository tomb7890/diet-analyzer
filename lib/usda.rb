# The Usda class is Ruby interface to the USDA's nutrition API.

class Usda
  include HTTParty

  base_uri 'api.nal.usda.gov'

  def self.api_key
    UsdaParty.config.api_key
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
    food_id_rjust = food_id.to_s.rjust(5, '0')
    options = {
      'ndbno' => food_id_rjust,
      'type' => 'b',
      'format' => 'json',
      'api_key' => api_key
    }
    get('/ndb/reports/',
        :query => options)['report']['food']
  end

  def self.search(string)
    options = {
      'format' => 'json',
      'q' => string,
      'api_key' => api_key
    }
    get('/ndb/search/',
        :query => options)['list']['item']
  end
end