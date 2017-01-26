# coding: utf-8
require 'nutrients'

module ApplicationHelper

  include Utility
  include Nutrients

  def measures_for_food(ndbno)
    response = Usda.caching_find(ndbno)
    array = response['nutrients'].first['measures'].map { |x| x['label'] }
    array.insert(0, 'g') unless array.include?('g')
    array
  end

  def piechartdata
    { 'Protein' => energy_from_protein,
      'Fat' => energy_from_fat,
      'Carbohydrate' => energy_from_carbohydrate
    }
  end

  def tab_pane_nutrients(category)
    y = case category
        when 'Vitamins'
          [
            [VITA_IU, 'IU'],
            [FOL, 'µg'],
            [THIA, 'mg'],
            [RIBF, 'mg'],
            [NIA, 'mg'],
            [PANTAC, 'mg'],
            [VITB6A, 'mg'],
            [VITB12, 'µg'],
            [VITC, 'mg'],
            [VITD, 'µg'],
            [TOCPHA, 'mg'],
            [VITK1,  'µg']
         ]
        when 'Minerals'
          [
            [CA, 'mg'],
            [CU, 'mg'],
            [FE, 'mg'],
            [MG, 'mg'],
            [MN, 'mg'],
            [P, 'mg'],
            [K, 'mg'],
            [SE, 'µg'],
            [NA, 'mg'],
            [ZN, 'mg']
          ]
        when 'Lipids'
          [
            [FASAT, 'g'],
            [FAMS, 'g'],
            [FAPU, 'g'],
            [CHOLE, 'mg'],
            ['Omega 3', 'g'],
            ['Omega 6', 'g'],
            [F18D3CN3, 'g'],
            [F20D3N3, 'mg'],
            [F22D6, 'mg'],
            [F20D5, 'mg'],
            [F22D5, 'mg']
         ]

        when 'Amino Acids'
          [
            [ALA_G, 'g'],
            [ARG_G, 'g'],
            [ASP_G, 'g'],
            [CYS_G, 'g'],
            [GLU_G, 'g'],
            [GLY_G, 'g'],
            [HISTN_G, 'g'],
            [HYP, 'g'],
            [ILE_G, 'g'],
            [LEU_G, 'g'],
            [LYS_G, 'g'],
            [MET_G, 'g'],
            [PHE_G, 'g'],
            [PRO_G, 'g'],
            [SER_G, 'g'],
            [THR_G, 'g'],
            [TRP_G, 'g'],
            [TYR_G, 'g'],
            [VAL_G, 'g']
         ]
        end
    y
  end

  def energy_from_carbohydrate
    sum = 4.0 * total_nutrient_amount(Nutrients::CHOCDF)
    sum
  end

  def energy_from_fat
    sum = 9.0 * total_nutrient_amount(Nutrients::FAT)
    sum
  end

  def energy_from_protein
    sum = 4.0 * total_nutrient_amount(Nutrients::PROCNT)
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
    sum
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
