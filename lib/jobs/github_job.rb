class GithubJob < ApiController
  def self.sync_repo
    _now = Time.new.day.even?
    Repo.all.each do |repo|
      if repo.id.even? == _now
        Github.sync_repo_attr repo
      end
    end
  end
end
