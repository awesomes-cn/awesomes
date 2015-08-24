class CreateMems < ActiveRecord::Migration
  def change
    create_table :mems do |t|
      t.string :nc
      t.string :email
      t.string :avatar
      t.timestamps null: false
    end
  end
end
