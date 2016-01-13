class Ad < ActiveRecord::Base
  belongs_to :adposition,foreign_key: 'key'
end
