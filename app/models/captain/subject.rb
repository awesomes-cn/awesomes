class Captain::Subject < ApplicationRecord
  include SubjectOrPracticeCommon
  has_many :practices, class_name: 'Captain::Practice'
end
