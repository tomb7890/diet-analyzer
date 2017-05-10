# coding: utf-8
require 'nutrients'

module ApplicationHelper

  include Utility
  include Nutrients
  include Goals

  def get_user_date_object
    d = nil
    begin
      userdate  = session[:current_user_date]
      d = DateTime.iso8601(userdate).to_date
    rescue ArgumentError => e
      d = nil
    end
    d
  end

  def display_the_date_helper
    session[:current_user_date]
  end

  def today?
    (DateTime.now).to_date == get_user_date_object
  end

  def tomorrow_date
    todays_date = (DateTime.now).to_date
    todays_date + 1
  end

  def offset_date(offset)
    the_date = get_user_date_object
    return the_date + offset unless the_date.nil?
  end

  def day_offset_link(offset)
    result = ''
    offset_date = offset_date(offset)
    if offset_date.beginning_of_day.to_i < tomorrow_date.beginning_of_day.to_i
      offset_date_string = offset_date.to_s
      result = foods_path(:date => (offset_date_string))
    end
    result
  end

  def previous_day_link
    day_offset_link(-1)
  end

  def next_day_link
    day_offset_link(+1)
  end

  def food_of_day
    d = session[:current_user_date]
    Food.created_on_day(d, current_user)
  end

  def measures_for_food(ndbno)
    response = Usda.caching_find(ndbno)
    array = response['nutrients'].first['measures'].map { |x| x['label'] }
    array.insert(0, 'g') unless array.include?('g')
    array
  end

  def piechartdata
    {
      'Protein' => energy_from_protein,
      'Fat' => energy_from_fat,
      'Carbohydrate' => energy_from_carbohydrate
    }
  end

  def energy_density_data
    hash = {}

    food_of_day.each do | f |
      if f.name
        key = f.name.split(/\W/).first
        value = energy_density(f.ndbno)
        hash[key] =value
      end
    end
    hash
  end

  def energy_from_carbohydrate
    energy_from_macro('cf', CALORIES_PER_GRAM_CARB, CHOCDF)
  end

  def energy_from_fat
    energy_from_macro('ff', CALORIES_PER_GRAM_FAT, FAT)
  end

  def energy_from_protein
    energy_from_macro('pf', CALORIES_PER_GRAM_PROTEIN, PROCNT)
  end

  def energy_from_sat_fat
    energy_from_macro('ff', CALORIES_PER_GRAM_FAT, FASAT)
  end

  def energy_from_trans_fat
    energy_from_macro('ff', CALORIES_PER_GRAM_FAT, FATRN)
  end

  def energy_from_macro(tag, standard_conversion_factor, nutrient)
    sum = 0
    food_of_day.each do |f |
      begin
        sum = sum + f.macro_energy(tag, standard_conversion_factor, nutrient)
      rescue TypeError => t
        Rails.logger.error "energy_from_macro(#{tag}, #{nutrient}, #{f.name}); #{t.class.name}: #{t.message}"
      end
    end
    sum
  end

  def daily_helper(n)
    sum = total_nutrient_amount(n)
    sum= formatit(sum)
  end

  def total_nutrient_amount(n = nil)
    sum = 0
    food_of_day.each do |f |
      if f.amount.class != String
        result = nutrient_per_serving(n,  f.ndbno, f.measure, f.amount)
        if result.class == Float
          sum += result
        end
      end
    end
    sum.to_f
  end

  def total_energy
    total_nutrient_amount(Nutrients::ENERC_KCAL)
  end

  def caching_search(term)
    unless term.blank?
      Rails.cache.fetch(term, expires_in: 28.days) do
        response = Usda.search(term)
      end
    end
  end

  def nutrients_for_food_panel(ndbno, quantity, measure = 'g')
    hash = {}

    hash['Energy'] = nutrient_per_serving(Nutrients::ENERC_KCAL,
                                          ndbno, measure, quantity)
    hash['Water'] = nutrient_per_serving(Nutrients::WATER,
                                         ndbno, measure, quantity)
    hash['Carbs'] = nutrient_per_serving(Nutrients::CHOCDF,
                                         ndbno, measure, quantity)
    hash['Fiber'] = nutrient_per_serving(Nutrients::FIBTG, ndbno,
                                         measure, quantity)
    hash['Protein'] = nutrient_per_serving(Nutrients::PROCNT, ndbno,
                                           measure, quantity)
    hash['Fat'] =   nutrient_per_serving(Nutrients::FAT, ndbno,
                                         measure, quantity)
    hash = format_hash_values(hash)
  end

  def format_hash_values(hash)
    hash.keys.each do |key|
      newvalue= formatit( hash[key])
      hash[key]=newvalue
    end
    hash
  end

  def list_for_select_options(hashes)
    array = []
    if hashes
      hashes.each do |h|
        if h.class == Hash && h.key?('name') && h.key?('ndbno')
          array_element = []
          array_element << h['name']
          array_element << h['ndbno']
          array << array_element
        end
      end
    end
    array
  end
end
