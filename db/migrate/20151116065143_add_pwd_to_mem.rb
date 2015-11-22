class AddPwdToMem < ActiveRecord::Migration
  def change
    add_column :mems, :pwd, :string
  end
end
