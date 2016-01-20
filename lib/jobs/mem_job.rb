require "github"
class MemJob < ApplicationController
  def self.aync_avatar
    _app = ApplicationController.new
    Mem.where("avatar like 'http%'").each do |mem|
      _name = "#{Time.now.strftime("%y%m%d%H%M%S")}-#{rand(99).to_s}.jpg"
      _app.upload_remote(mem.avatar,_name,'mem')
      mem.update_attributes({:avatar=> _name})
      p "=====#{mem.id}====="
    end  
    p "=====success aync avatar====="
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
    MemMailer.promotion("").deliver
    p "======send promotion email ok ============="
  end
end
