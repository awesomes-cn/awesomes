class AddWeathToMem < ActiveRecord::Migration[5.0]
  def change
    add_column :mems, :wealth, :float, :default=> 0
  end
end
