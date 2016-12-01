class AddFavorCommentToCode < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :favor, :integer, :default=> '0'
    add_column :codes, :comment, :integer, :default=> '0'
  end
end
