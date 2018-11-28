class AddHeightToUser < ActiveRecord::Migration
  def change
    add_column :users, :heightcm, :float
  end
end
