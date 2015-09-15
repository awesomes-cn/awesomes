class AddTagToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :tag, :string #标签
  end
end
