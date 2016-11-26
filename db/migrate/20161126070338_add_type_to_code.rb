class AddTypeToCode < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :typcd, :string, :default=> 'repo'  #代码类型 repo  css
  end
end
