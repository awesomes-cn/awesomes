class CreateRepoTransLocks < ActiveRecord::Migration[5.0]
  def change
    create_table :repo_trans_locks do |t|
      t.belongs_to :mem
      t.belongs_to :repo
      t.timestamps
    end
  end
end
