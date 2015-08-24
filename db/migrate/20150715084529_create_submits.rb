class CreateSubmits < ActiveRecord::Migration
  def change
    create_table :submits do |t|
      t.string :html_url
      t.string :rootyp
      t.string :typcd
      t.string :status,:default=> "UNREAD"  #UNREAD  READED  是否已审核
      t.timestamps null: false
    end
  end
end
