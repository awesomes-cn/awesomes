class CreateOpers < ActiveRecord::Migration
  def change
    create_table :opers do |t|
      t.string :typ  #操作对象的类型
      t.integer :idcd  #操作对象的ID
      t.belongs_to :mem
      t.string :opertyp #操作类型
      t.timestamps null: false
    end
  end
end
