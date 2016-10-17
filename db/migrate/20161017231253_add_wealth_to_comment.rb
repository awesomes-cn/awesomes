class AddWealthToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :wealth, :float, :default=> 0
  end
end
