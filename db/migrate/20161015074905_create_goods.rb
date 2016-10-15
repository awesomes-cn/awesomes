class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
      t.string :name
      t.string :cover
      t.text :desc
      t.float :price
      t.integer :order
      t.timestamps
    end
  end
end
