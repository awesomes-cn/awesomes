class CreateCaptainGithubRepoOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :captain_github_repo_owners do |t|
      t.string :login
      t.string :avatar_url
      t.string :home

      t.timestamps
    end
  end
end
