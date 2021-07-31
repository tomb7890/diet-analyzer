module Goals

  CALORIES_PER_GRAM_FAT=9.0
  CALORIES_PER_GRAM_CARB=4.0
  CALORIES_PER_GRAM_PROTEIN=4.0

  def fruit_and_veg_goal(collection)
    # At least 400 g (5 portions) of fruits and vegetables a day
    # (2). Potatoes, sweet potatoes, cassava and other starchy roots are
    # not classified as fruits or vegetables.
    amount = 0.0
    collection.each do |f|
      x = fresh_fruit_or_veg(f)
      if x.class != String
        amount = amount + x
      end
    end
    amount
  end

  def fresh_fruit_or_veg(database_item)
    amt = 0
    if food_is_a_fresh_vegtable_or_fruit(database_item)
      amt = gram_equivalent(database_item.fdcid, database_item.measure) * database_item.amount
    end
    amt
  end

  def food_is_a_fresh_vegtable_or_fruit(database_item)
    x = false
    foodgroups = ['Vegetables and Vegetable Products',
      'Fruits and Fruit Juices']
    food = Fdcapi.caching_find(database_item.fdcid)
    if food.has_key? 'foodCategory'
      cat = food['foodCategory']
      if cat.has_key? 'description'
        foodgroup = cat['description']
        x= (foodgroups.include? foodgroup) && food_name_contains_raw(database_item)
      end
    end
    x
  end

  def food_name_contains_raw(food)
    food.name =~ /\braw\b/i
  end

  def goal_fruit_and_veg(foods)
    value = fruit_and_veg_goal(foods)
    "Fruit and veg goal: #{value}"
  end

  def yes_no_helper(condition)
    if condition
      'yes'
    else
      'no'
    end
  end

  def goal_cholesterol(foods)
    yes_no_helper(total_nutrient_amount(foods, Nutrients::CHOLE).to_f < 300)
  end

  def goal_dietaryfat(foods)
    yes_no_helper(goal_dietaryfat_helper(energy_from_fat(foods), total_energy(foods)))
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

  def goal_satfat(foods)
    yes_no_helper(goal_satfat_helper(energy_from_sat_fat(foods), total_energy(foods)))
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

  def goal_transfat(foods)
    yes_no_helper(goal_transfat_helper( energy_from_trans_fat(foods), total_energy(foods)))
  end

 def goal_transfat_helper( energy_from_trans_fat, total_energy )
    success = true
    if energy_from_trans_fat > 0
      success = false
    end
    success
  end

  def goal_fiber(foods)
    yes_no_helper(total_nutrient_amount(foods, Nutrients::FIBTG) > 15)
  end

  def goal_sodium(foods)
    yes_no_helper(total_nutrient_amount(foods, Nutrients::NA) < 2300)
  end
end
