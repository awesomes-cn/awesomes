class CreateCaptainSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :captain_subjects do |t|
      t.string :name
      t.string :desc
      t.string :code
      t.string :icon

      t.timestamps
    end
  end
end
