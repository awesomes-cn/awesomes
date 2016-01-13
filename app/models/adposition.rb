class Adposition < ActiveRecord::Base
  has_many :ads,foreign_key: 'position'
end
