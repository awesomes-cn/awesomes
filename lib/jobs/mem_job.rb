require "github"
class MemJob < ApplicationController
  def self.aync_avatar
    _log = Log.task_begin('MEMAvatar', '用户头像同步')
    _app = ApplicationController.new
    Mem.where("avatar like 'http%'").each do |mem|
      _name = "#{Time.now.strftime("%y%m%d%H%M%S")}-#{rand(99).to_s}.jpg"
      _app.upload_remote(mem.avatar,_name,'mem')
      mem.update_attributes({:avatar=> _name})
      p "=====#{mem.id}====="
    end  
    _log.task_end
  end

  def self.aync_rank
    Mem.all.each do |mem|
      if !(_github = mem.mem_info.github).blank?
        Github.sync_mem_rank mem
        p "=====aync rank  #{mem.id}====="
      end
    end   
    p "=====success aync rank====="
  end

  def self.promotion
    _arr = []
    File.open("/home/hxh/share/emails.txt") do |file|  
      file.each_line do |line| 
        _arr << line 
      end
      file.close();  
    end
    _arr.uniq.each_with_index do |item,index|
      MemMailer.promotion(item).deliver
      puts "send  #{index} : #{item}"
      sleep 30
    end
    p "======send promotion email ok ============="
  end
end
