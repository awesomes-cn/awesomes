class RepoTransLock < ApplicationRecord
  belongs_to :mem
  belongs_to :repo
end
