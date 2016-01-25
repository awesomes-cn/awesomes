class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name
      t.string :logo
      t.string :url
      t.integer :order,:default=> 0
      t.string :sdesc
      t.timestamps null: false
    end
  end
end
