class Captain::GithubRepo < ApplicationRecord
  belongs_to :owner, class_name: 'Captain::GithubRepoOwner'
  has_one :doc, class_name: 'Captain::GithubRepoDoc', foreign_key: :repo_id
end
