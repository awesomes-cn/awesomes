
namespace :repo do 
  task :sync,[:start] => :environment do |t,args|
   GithubJob.sync_repo args[:start]
  end

  task :trend,[:start] => :environment do |t,args|
   GithubJob.repo_trend args[:start]
  end

  task :trend_log,[:start] => :environment do |t,args|
    Repo.all.each do |repo|
      repo.repo_trends.each_with_index do |item,index|
        _prev = repo.repo_trends[index - 1]
        if index == 0
          _trend = 0
        else
          _trend = (item.overall - _prev.overall) /  (item.date - _prev.date)
        end
        
        item.update_attributes({:trend=> _trend})
      end
      p "======#{repo.id}======"
    end
    p "======success======"
  end 

  task :cover,[:start] => :environment do |t,args|
    GithubJob.repo_cover
  end
   
end


namespace :mem do 
  task :avatar,[:start] => :environment do |t,args| 
    MemJob.aync_avatar
  end
end

