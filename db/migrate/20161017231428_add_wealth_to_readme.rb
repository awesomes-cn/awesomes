class AddWealthToReadme < ActiveRecord::Migration[5.0]
  def change
    add_column :readmes, :wealth, :float, :default=> 0
  end
end
