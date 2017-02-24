module Goals

  CALORIES_PER_GRAM_FAT=9.0
  CALORIES_PER_GRAM_CARB=4.0
  CALORIES_PER_GRAM_PROTEIN=9.0

  def fruit_and_veg_goal
    # At least 400 g (5 portions) of fruits and vegetables a day
    # (2). Potatoes, sweet potatoes, cassava and other starchy roots are
    # not classified as fruits or vegetables.
    amount = 0.0
    @foods.each do |f|
      x = fresh_fruit_or_veg(f)
      amount = x + amount
    end
    amount.to_s
  end

  def fresh_fruit_or_veg(database_item)
    amt = 0
    fullreport = Usda.caching_find(database_item.ndbno)
    unless fullreport.nil?
      if food_is_a_fresh_vegtable_or_fruit(fullreport)
        amt = gram_equivelent(database_item.ndbno, database_item.measure) * database_item.amount
      end
    end
    amt
  end

  def food_is_a_fresh_vegtable_or_fruit(response)
    foodgroups = [
      'Vegetables and Vegetable Products',
      'Fruits and Fruit Juices']
    fg = response['fg']
    (foodgroups.include? fg) && food_name_contains_the_string_raw(response)
  end

  def food_name_contains_the_string_raw(response)
    response['name'] =~ /\braw\b/i
  end

  def goal_fruit_and_veg
    "Fruit and veg goal: #{fruit_and_veg_goal}"
  end

  def yes_no_helper(condition)
    if condition
      'yes'
    else
      'no'
    end
  end

  def goal_cholesterol
    yes_no_helper(total_nutrient_amount(Nutrients::CHOLE).to_f < 300)
  end

  def goal_dietaryfat
    yes_no_helper(goal_dietaryfat_helper(energy_from_fat, total_energy))
  end

  def goal_dietaryfat_helper( energy_from_fat, total_energy )
    success = true
    if total_energy > 0
      proportion = energy_from_fat / total_energy
      if proportion > 0.3
        success = false
      end
    end
    success
  end

  def goal_satfat
    yes_no_helper(goal_satfat_helper(energy_from_sat_fat, total_energy))
  end

  def goal_satfat_helper(energy_from_sat_fat, total_energy)
    success = true
    if total_energy > 0
      proportion = energy_from_sat_fat / total_energy
      if (proportion < 0.10)
        success = true
      end
    end
    success
  end

  def goal_transfat
    yes_no_helper(goal_transfat_helper( energy_from_trans_fat, total_energy))
  end

 def goal_transfat_helper( energy_from_trans_fat, total_energy )
    success = true
    if energy_from_trans_fat > 0
      success = false
    end
    success
  end

  def goal_fiber
    yes_no_helper(total_nutrient_amount(Nutrients::FIBTG) > 15)
  end

  def goal_sodium
    yes_no_helper(total_nutrient_amount(Nutrients::NA) < 2300)
  end
end
