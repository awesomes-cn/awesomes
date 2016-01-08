class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :key
      t.string :title
      t.string :cover
      t.string :sdesc
      t.integer :order,:default=> 0
      t.integer :amount,:default=> 0
      t.timestamps null: false
    end
  end
end
