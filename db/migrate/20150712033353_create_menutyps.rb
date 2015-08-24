class CreateMenutyps < ActiveRecord::Migration
  def change
    create_table :menutyps do |t|
      t.string :key
      t.string :sdesc
      t.string :fdesc
      t.string :parent
      t.string :typcd  
      t.text :home
      t.integer :num,:default=> 0
      t.string :icon

      t.timestamps null: false
    end
  end
end
