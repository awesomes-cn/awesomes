require 'rufus/scheduler'
require "jobs/github_job"
scheduler = Rufus::Scheduler.new


# 每天凌晨2点执行 
scheduler.cron '0 2 * * *' do
  GithubJob.sync_repo
end 

# 每隔3天执行
scheduler.cron '0 4 */3 * *' do
  GithubJob.repo_trend
end 
