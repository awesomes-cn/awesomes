class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :full_name
      t.string :alia #用于浏览器url显示的
      t.string :html_url
      t.string :description
      t.string :homepage
      t.integer :stargazers_count   #star
      t.integer :forks_count        #fork
      t.integer :subscribers_count  #watch
      t.datetime :pushed_at  #更新时间
      t.text :about
      t.text :about_zh
      t.string :typcd
      t.string :rootyp
      t.string :owner
      t.timestamps null: false
    end
  end
end
