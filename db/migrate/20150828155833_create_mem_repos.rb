class CreateMemRepos < ActiveRecord::Migration
  def change
    create_table :mem_repos do |t|
      t.belongs_to :mem
      t.string :name
      t.string :description
      t.string :html_url
      t.integer :stargazers_count   #star
      t.timestamps null: false
    end
  end
end
