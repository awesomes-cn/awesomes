require "github"
class GithubJob < ApplicationController
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
end
