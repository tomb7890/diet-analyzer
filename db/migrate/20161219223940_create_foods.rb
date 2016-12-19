class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.integer :ndbno
      t.string :measure
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
