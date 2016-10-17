class AddWealthToCode < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :wealth, :float, :default=> 0
  end
end
