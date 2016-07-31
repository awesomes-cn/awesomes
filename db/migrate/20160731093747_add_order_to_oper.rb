class AddOrderToOper < ActiveRecord::Migration[5.0]
  def change
    add_column :opers, :order, :integer, :default=> 0
  end
end
