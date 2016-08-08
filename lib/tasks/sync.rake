
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

  task :issue,[:start] => :environment do |t,args|
    GithubJob.repo_issue
  end


  task :index,[:start] => :environment do |t,args|
    Repo.reindex
  end

   
end


namespace :mem do 
  task :avatar,[:start] => :environment do |t,args| 
    MemJob.aync_avatar
  end

  task :rank,[:start] => :environment do |t,args| 
    MemJob.aync_rank
  end

  task :email,[:start] => :environment do |t,args| 
    MemJob.promotion
  end
end







namespace :baidu do 
  task :push,[:start] => :environment do |t,args| 
    Topic.push_seo
  end
end


