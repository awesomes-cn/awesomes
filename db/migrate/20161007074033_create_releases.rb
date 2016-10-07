class CreateReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :releases do |t|
      t.belongs_to :repo
      t.string :tag_name
      t.datetime :published_at
      t.text :body
      t.boolean :prerelease
      t.timestamps
    end
  end
end
