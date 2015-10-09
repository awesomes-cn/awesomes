namespace :repo do 
  task :sync,[:start] => :environment do |t,args|
   GithubJob.sync_repo args[:start]
  end

  task :trend,[:start] => :environment do |t,args|
   GithubJob.repo_trend args[:start]
  end
end


