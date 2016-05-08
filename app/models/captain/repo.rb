class Captain::Repo < ApplicationRecord
  class Status
    WAIT_TO_APPROVE = 'wait_to_approve'
    APPROVED = 'approved'
    REJECTED = 'rejected'
  end

  belongs_to :practice, class_name: 'Captain::Practice'
end
