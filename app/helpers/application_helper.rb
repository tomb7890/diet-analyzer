# coding: utf-8
require 'nutrients'

module ApplicationHelper

  include Utility
  include Nutrients
  include Goals

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
    Food.all.each do |f|
      if f.name
        key = f.name.split(/\W/).first
        value = energy_density(f.ndbno)
        hash[key] =value
      end
    end
    hash
  end

  def energy_from_carbohydrate
    sum = 0
    Food.all.each do |f|
      sum = sum + f.carb_energy
    end
    sum
  end

  def energy_from_fat
    sum = 0
    Food.all.each do |f|
      sum = sum + f.fat_energy
    end
    sum
  end

  def energy_from_protein
    sum = 0
    Food.all.each do |f|
      sum = sum + f.protein_energy
    end
    sum
  end

  def daily_helper(n)
    sum = total_nutrient_amount(n)
    sum= formatit(sum)
  end

  def total_nutrient_amount(n = nil)
    sum = 0
    Food.all.each do |f|
      if f.amount.class != String
        result = nutrient_per_measure(n,  f.ndbno, f.measure, f.amount)
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

    hash['Energy'] = nutrient_per_measure(Nutrients::ENERC_KCAL,
                                          ndbno, measure, quantity)
    hash['Water'] = nutrient_per_measure(Nutrients::WATER,
                                         ndbno, measure, quantity)
    hash['Carbs'] = nutrient_per_measure(Nutrients::CHOCDF,
                                         ndbno, measure, quantity)
    hash['Fiber'] = nutrient_per_measure(Nutrients::FIBTG, ndbno,
                                         measure, quantity)
    hash['Protein'] = nutrient_per_measure(Nutrients::PROCNT, ndbno,
                                           measure, quantity)
    hash['Fat'] =   nutrient_per_measure(Nutrients::FAT, ndbno,
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
