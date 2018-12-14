class AddActivityLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :activitylevel, :float 
  end
end
