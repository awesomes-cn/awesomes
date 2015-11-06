class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.text :con
      t.string :typcd
      t.belongs_to :mem
      t.string :author
      t.string :origin
      t.string :state,:limit=> 1,:default=> '1'  #是否审核

      t.integer :visit,:default=> 0
      t.integer :favor,:default=> 0
      t.integer :comment,:default=> 0

      t.string :tag

      t.string :var1
      t.string :var2
      t.integer :var3

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
