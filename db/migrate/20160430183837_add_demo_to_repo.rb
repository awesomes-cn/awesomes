class AddDemoToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :demo, :integer
    add_column :repos, :startup, :integer
  end
end
