class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
    	t.string :typ
    	t.string :sdesc
    	t.text :fdesc
    	t.integer :var

      t.timestamps null: false
    end
  end
end
