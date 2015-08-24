class CreateReadmes < ActiveRecord::Migration
  def change
    create_table :readmes do |t|
      t.belongs_to :mem
      t.belongs_to :repo
      t.text :about
      t.text :old
      t.string :sdesc
      t.string :status,:default=> "UNREAD"  #UNREAD  READED  是否已审核

      t.timestamps null: false
    end
  end
end
