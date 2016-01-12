class AddWebsiteToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :website, :string
  end
end
