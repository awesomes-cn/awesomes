class RepoResource < ActiveRecord::Base
	belongs_to :mem
	belongs_to :repo
end
