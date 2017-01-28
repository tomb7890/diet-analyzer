module Goals

  def fruit_and_veg_goal
    # At least 400 g (5 portions) of fruits and vegetables a day
    # (2). Potatoes, sweet potatoes, cassava and other starchy roots are
    # not classified as fruits or vegetables.
    amount = 0.0
    @foods.each do |f|
      amount += fresh_fruit_or_veg(f)
    end
    amount.to_s
  end

  def fresh_fruit_or_veg(f)
    amt = 0
    response = Usda.caching_find(f.ndbno)
    unless response.nil?
      if food_is_a_fresh_vegtable_or_fruit(response)
        amt = gram_equivelent(f.ndbno, f.measure)
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
    x = if condition
          'yes'
        else
          'no'
        end
    x
  end

  def goal_cholesterol
    yes_no_helper(Nutrients::CHOLE.to_f < 300)
  end

  def goal_dietaryfat
    yes_no_helper((energy_from_fat.to_f /
                   daily_helper(Nutrients::ENERC_KCAL).to_f) < 0.30)
  end

  def goal_satfat
    yes_no_helper((energy_from_fat.to_f /
                    daily_helper(Nutrients::FASAT).to_f) < 0.10)
  end

  def goal_transfat
    yes_no_helper(daily_helper(Nutrients::FATRN).to_f > 0.0)
  end

  def goal_fiber
    yes_no_helper(daily_helper(Nutrients::FIBTG).to_f > 15)
  end

  def goal_sodium
    yes_no_helper(daily_helper(Nutrients::NA).to_f < 2300)
  end
end
