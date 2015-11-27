class CreateNotifies < ActiveRecord::Migration
  def change
    create_table :notifies do |t|
      t.belongs_to :mem   
      t.string :typcd     #消息類型
      t.integer :amount,:default=> 0   #消息數量
      t.string :desc
      t.string :fdesc
      t.string :state,:default=> 'UNREAD'     #UNREAD  READED
      t.timestamps null: false
    end
  end
end
