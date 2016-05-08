class Captain::GithubRepoDoc < ApplicationRecord
  belongs_to :github_repo, class_name: 'Captain::GithubRepo'
end
