class AddOutdatedToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :outdated, :string,:limit=> 1,:default=> '0' #readme 是否是最新的  0 ：最新的  1： 过时的
  end
end
