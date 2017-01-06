class AddContributeToReadme < ActiveRecord::Migration[5.0]
  def change
    add_column :readmes, :contribute, :integer, :default=> 0  #贡献值  新增=字数？
  end
end
