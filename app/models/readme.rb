class Readme < ActiveRecord::Base
  belongs_to :mem
  belongs_to :repo

  def friendly_time 
    created_at.friendly_i18n  
  end
end
