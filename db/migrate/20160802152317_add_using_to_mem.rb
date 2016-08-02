class AddUsingToMem < ActiveRecord::Migration[5.0]
  def change
    add_column :mems, :using, :integer, :default=> 0
  end
end
