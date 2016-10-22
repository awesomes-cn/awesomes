class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.belongs_to :good
      t.belongs_to :mem
      t.integer :amount
      t.float :price
      t.float :total_price
      t.string :remark
      t.string :state # 待确认   待发货  已发货  完成
      t.timestamps
    end
  end
end
