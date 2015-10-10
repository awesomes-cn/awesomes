require "github"
class GithubJob < ApiController
  def self.sync_repo
    Thread.new{
      Repo.all.each do |repo|
        _repo = Github.sync_repo_attr(repo)
        p "====成功同步：#{repo.id}======="
        sleep 5 
      end
    }.join
  end

  def self.repo_trend
    Repo.all.each do |item|
      item.update_trend
      p "====#{item.id}======="
    end
  end
end
