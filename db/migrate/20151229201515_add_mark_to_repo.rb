class AddMarkToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :mark, :integer,:default=> 0
  end
end
