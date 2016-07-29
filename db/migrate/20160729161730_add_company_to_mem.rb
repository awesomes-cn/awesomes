class AddCompanyToMem < ActiveRecord::Migration[5.0]
  def change
    add_column :mem_infos, :company, :string
    add_column :mem_infos, :job, :string
  end
end
