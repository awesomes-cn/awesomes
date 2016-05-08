class Captain::Practice < ApplicationRecord
  include SubjectOrPracticeCommon

  belongs_to :subject, class_name: 'Captain::Subject'
  has_many :repos, class_name: 'Captain::Repo'

end
