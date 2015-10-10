class CreateRepoTrends < ActiveRecord::Migration
  def change
    create_table :repo_trends do |t|
      t.belongs_to :repo
      t.integer :overall  #综合评分
      t.date :date #记录时间
      t.timestamps null: false
    end
  end
end
