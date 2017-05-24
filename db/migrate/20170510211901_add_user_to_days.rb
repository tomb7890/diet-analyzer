class AddUserToDays < ActiveRecord::Migration
  def change
    add_reference :days, :user, index: true, foreign_key: true
  end
end
