class AddTypeZhToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :typcd_zh, :string
    add_column :repos, :rootyp_zh, :string
  end
end
