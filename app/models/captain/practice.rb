class Captain::Practice < ApplicationRecord
  include SubjectOrPracticeCommon
  belongs_to :subject, class_name: 'Captain::Subject'
end
