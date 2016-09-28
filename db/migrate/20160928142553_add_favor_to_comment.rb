class AddFavorToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :favor, :integer, :default=> 0 
  end
end
