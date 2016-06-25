class AddHidetagsToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :hidetags, :string
  end
end
