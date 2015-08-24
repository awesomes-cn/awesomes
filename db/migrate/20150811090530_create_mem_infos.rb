class CreateMemInfos < ActiveRecord::Migration
  def change
    create_table :mem_infos do |t|
      t.belongs_to :mem
      t.string :gender
      t.string :location
      t.string :html_url #github 主页
      t.string :blog #个人主页

      t.integer :followers
      t.integer :following

      t.timestamps null: false
    end
  end
end
