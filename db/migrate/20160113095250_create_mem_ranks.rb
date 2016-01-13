class CreateMemRanks < ActiveRecord::Migration
  def change
    create_table :mem_ranks do |t|
      t.belongs_to :mem
      t.integer :worldwide
      t.integer :country
      t.timestamps null: false
    end
  end
end
