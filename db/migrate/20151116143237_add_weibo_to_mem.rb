class AddWeiboToMem < ActiveRecord::Migration
  def change
    add_column :mem_infos, :weibo_nc, :string
    add_column :mem_infos, :weibo_url, :string
  end
end
