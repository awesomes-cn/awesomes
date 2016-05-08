class CreateCaptainPractices < ActiveRecord::Migration[5.0]
  def change
    create_table :captain_practices do |t|
      t.string :name
      t.string :code
      t.string :icon
      t.string :desc
      t.integer :subject_id

      t.timestamps
    end
  end
end
