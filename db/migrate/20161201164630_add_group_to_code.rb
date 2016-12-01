class AddGroupToCode < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :group, :string
  end
end
