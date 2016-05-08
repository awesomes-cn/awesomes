class Captain::GithubRepoOwner < ApplicationRecord
  has_many :repos, class_name: 'Captain::GithubRepo'
end
