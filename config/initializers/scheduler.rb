require 'rufus/scheduler'
require "jobs/github_job"
require "jobs/mem_job"
scheduler = Rufus::Scheduler.new


# 每天凌晨2点执行 
scheduler.cron '0 2 * * *' do
  GithubJob.sync_repo
end 

# 每隔4天执行
scheduler.cron '0 6 */4 * *' do
  GithubJob.repo_trend
end 


# 每天凌晨1点执行 
scheduler.cron '0 1 * * *' do
  MemJob.aync_avatar
end