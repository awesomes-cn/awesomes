class AddRoleToMem < ActiveRecord::Migration[5.0]
  def change
    add_column :mems, :role, :string, :default=> 'user'
    # user 普通会员
    # vip  高级会员
  end
end
