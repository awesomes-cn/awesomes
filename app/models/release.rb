class Release < ApplicationRecord
  belongs_to :repo


  def friendly_time 
    published_at.friendly_i18n  
  end
  
end
