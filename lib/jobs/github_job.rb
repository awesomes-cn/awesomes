require "github"
class GithubJob < ApplicationController
  def self.sync_repo start = 1
    Thread.new{
      _log = Log.task_begin('RepoInfo', 'Repo信息')
      Repo.where("id >= #{start.to_i}").each do |repo|
        _repo = Github.sync_repo_attr(repo)
        p "====#{repo.id}======="
        sleep 5 
      end
      _log.task_end
    }.join
  end

  def self.repo_trend start = 1
    _log = Log.task_begin('RepoTrend', 'Repo趋势')
    Repo.where("id >= #{start.to_i}").each do |item|
      item.update_trend
      p "====#{item.id}======="
      sleep 1
    end
    _log.task_end
  end

  def self.repo_cover start = 1
    _app = ApplicationController.new
    Repo.where(:cover=> [nil,'default.jpg']).each do |item| 
      _cover = Github.get_repo_cover item
      p "========#{_cover}=========="
      _name = "#{Time.now.strftime("%y%m%d%H%M%S")}-#{rand(99).to_s}.jpg"
      _app.upload_remote(_cover,_name,'repo')
      item.update_attributes({:cover=> _name})
      p "====#{item.id}======="
    end
  end

  def self.repo_issue
    _log = Log.task_begin('RepoIssue', 'Repo issue处理')
    Repo.all.each do |item| 
      Github.get_repo_issue(item)
      p "====#{item.id}======="
      sleep 2
    end
    _log.task_end
  end

  def self.repo_release start = 1
    _log = Log.task_begin('RepoRelease', 'Repo 最新版本')
    Repo.where(['stargazers_count > ?', 1000]).each do |item| 
      Github.get_repo_release(item)
      p "====#{item.id}======="
      sleep 2
    end
    _log.task_end
  end
end
