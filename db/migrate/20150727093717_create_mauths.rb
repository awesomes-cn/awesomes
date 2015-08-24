class CreateMauths < ActiveRecord::Migration
  def change
    create_table :mauths do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.belongs_to :mem

      t.string :provider
      t.string :uid
      t.timestamps null: false
    end
  end
end
