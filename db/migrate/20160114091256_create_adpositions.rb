class CreateAdpositions < ActiveRecord::Migration
  def change
    create_table :adpositions do |t|
      t.string :name
      t.string :key
      t.timestamps null: false
    end
  end
end
