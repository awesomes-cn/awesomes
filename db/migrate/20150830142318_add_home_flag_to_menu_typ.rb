class AddHomeFlagToMenuTyp < ActiveRecord::Migration
  def change
    add_column :menutyps, :home_index, :integer,:default=> 0 #首页显示的Index
  end
end
