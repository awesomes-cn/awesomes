class CreateRepoResources < ActiveRecord::Migration
  def change
    create_table :repo_resources do |t|
    	t.string :recsts,:default=> '1'
    	t.string :title
    	t.string :url
    	t.belongs_to :repo
    	t.belongs_to :mem
      t.timestamps null: false
    end
  end
end
