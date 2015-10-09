require "github"
class GithubJob < ApiController
  def self.sync_repo start = 1
    Thread.new{
      Repo.where("id >= #{start.to_i}").each do |repo|
        _repo = Github.sync_repo_attr(repo)
        p "====#{repo.id}======="
        sleep 5 
      end
    }.join
  end

  def self.repo_trend start = 1
    Repo.where("id >= #{start.to_i}").each do |item|
      item.update_trend
      p "====#{item.id}======="
    end
  end
end
