class AddTrendToRepoTrends < ActiveRecord::Migration
  def change
    add_column :repo_trends, :trend, :integer,:default=> 0
  end
end
