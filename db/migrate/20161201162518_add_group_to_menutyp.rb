class AddGroupToMenutyp < ActiveRecord::Migration[5.0]
  def change
    add_column :menutyps, :group, :string, :default=> 'REPO'
  end
end
