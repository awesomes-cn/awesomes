class AddRepoIdToSubject < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :repo_id, :integer
  end
end
