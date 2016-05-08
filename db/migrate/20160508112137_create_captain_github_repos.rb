class CreateCaptainGithubRepos < ActiveRecord::Migration[5.0]
  def change
    create_table :captain_github_repos do |t|
      t.string :name
      t.string :full_name
      t.string :alia
      t.string :html_url
      t.string :homepage
      t.text :description
      t.integer :owner_id
      t.integer :stargazers_count
      t.integer :forks_count
      t.integer :subscribers_count
      t.integer :watchers_count
      t.string :language
      t.string :favicon
      t.string :repo_pushed_at
      t.string :repo_created_at
      t.string :repo_updated_at


      t.timestamps
    end
  end
end
