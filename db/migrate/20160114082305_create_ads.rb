class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :position
      t.string :name
      t.string :image
      t.string :link
      t.text :html
      t.integer :visit,:default=> 0
      t.timestamps null: false
    end
  end
end
