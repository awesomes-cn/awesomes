class AddAliaToMenutyps < ActiveRecord::Migration[5.0]
  def change
    add_column :menutyps, :alia, :string  #别名，便于搜索
  end
end
