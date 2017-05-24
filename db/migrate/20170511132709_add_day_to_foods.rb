class AddDayToFoods < ActiveRecord::Migration
  def change
    add_reference :foods, :day, index: true, foreign_key: true
  end
end
