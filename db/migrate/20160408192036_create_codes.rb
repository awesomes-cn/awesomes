class CreateCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :codes do |t|
      t.belongs_to :mem
      t.belongs_to :repo

      t.string :title

      
      t.text :css 
      t.text :js
      t.text :html

      t.timestamps
    end
  end
end
