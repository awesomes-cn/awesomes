class AddExperienceToRepo < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :experience, :integer, :default=> 0  #经验数量
  end
end
