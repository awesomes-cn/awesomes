namespace :repo do 
  task :sync,[:table] => :environment do |t,args|
   GithubJob.sync_repo 
  end

  task :trend,[:table] => :environment do |t,args|
   GithubJob.repo_trend 
  end
end


