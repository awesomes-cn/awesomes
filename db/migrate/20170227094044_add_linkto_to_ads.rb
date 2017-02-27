class AddLinktoToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :linkto, :text #链接地址 之前的 link 字段为 string 太短
  end
end
