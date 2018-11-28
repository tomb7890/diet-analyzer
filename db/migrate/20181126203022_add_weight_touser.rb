class AddWeightTouser < ActiveRecord::Migration
  def change
    add_column :users, :weightkg, :float
  end
end
