class CreateMsgs < ActiveRecord::Migration[5.0]
  def change
    create_table :msgs do |t|
      t.string :title
      t.text :con
      t.string :level   #级别  
      t.string :typ     #类型
      t.integer :from
      t.integer :to
      t.string :status, :default=> 'UNREAD'   # UNREAD  READED
      t.timestamps
    end
  end
end
