class AddParaToMemInfo < ActiveRecord::Migration
  def change
    add_column :mem_infos, :github, :string #Github 用户名
    add_column :mem_infos, :twitter, :string #twitter 用户名
  end
end
