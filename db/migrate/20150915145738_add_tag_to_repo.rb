class AddTagToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :tag, :string #标签
    add_column :repos, :cover, :string #封面
    add_column :repos, :recommend, :integer,:default=> 0 #推荐
  end
end
