# The Usda class is Ruby interface to the USDA's nutrition API.

class Usda
  include HTTParty

  base_uri 'api.nal.usda.gov'

  def self.api_key
    ENV['USDA_NDL_API_KEY']
  end

  def self.find(food_id)
    food = nil
    food_id_rjust = food_id.to_s.rjust(5, '0')
    options = {
      'ndbno' => food_id_rjust,
      'type' => 'f',
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
