class Mem < ActiveRecord::Base
  include LetterAvatar::AvatarHelper
  has_many :readmes
  has_many :mauths
  has_many :docsubs
  has_many :docs
  has_many :repo_resources
  has_one :mem_infos
  has_many :comments
  has_many :mem_repos
  has_many :topics


  def mem_info
    MemInfo.find_by_mem_id(id) || MemInfo.create({:mem_id=> id})     
  end

  def avatar_url
    avatar.blank? ? letter_avatar_for(nc_for_avatar, 150).sub(/public/,'') : "#{Rails.application.config.source_access_path}mem/#{avatar}"
  end

  def index
    Mem.where("id < ?",id).count + 1
  end

  def nc_for_avatar
    Pinyin.t(nc)
  end

end
