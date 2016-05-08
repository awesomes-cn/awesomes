class CreateCaptainRepos < ActiveRecord::Migration[5.0]
  def change
    create_table :captain_repos do |t|
      t.string :name
      t.string :url
      t.string :status
      t.integer :practice_id

      t.timestamps
    end
  end
end
