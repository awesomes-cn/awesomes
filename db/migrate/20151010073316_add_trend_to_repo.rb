class AddTrendToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :trend, :integer,:default=> 0
    add_column :repos, :github_created_at, :datetime
  end
end
