class AddIssueResponseToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :issue_res, :integer, :default=> 0 #issue处理速度 秒
  end
end
