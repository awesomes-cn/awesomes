class CreateCaptainGithubRepoDocs < ActiveRecord::Migration[5.0]
  def change
    create_table :captain_github_repo_docs do |t|
      t.longtext :readme_en
      t.longtext :readme_zh
      t.integer :repo_id

      t.timestamps
    end
  end
end
