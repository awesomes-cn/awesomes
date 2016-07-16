class AddUsingToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :using, :integer, :default=> 0
  end
end
