class AddReputationToMem < ActiveRecord::Migration[5.0]
  def change
    add_column :mems, :reputation, :integer, :default=> 0
  end
end
