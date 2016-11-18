class Subject < ActiveRecord::Base
  belongs_to :repo

  def cover_path
    "#{Rails.application.config.source_access_path}subject/#{cover}"
  end

end
