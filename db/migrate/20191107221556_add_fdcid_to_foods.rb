class AddFdcidToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :fdcid, :integer
  end
end
