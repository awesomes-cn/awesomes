class CreateWealthLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :wealth_logs do |t|
      t.belongs_to :mem
      t.float :amount
      t.float :balance
      t.string :remark
      t.string :flag
      t.timestamps
    end
  end
end
