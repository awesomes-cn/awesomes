class Mem < ActiveRecord::Base
  has_many :readmes
  has_many :mauths
  has_many :docsubs
  has_many :docs
  has_many :repo_resources
  has_one :mem_infos
  has_many :comments
  has_many :mem_repos
  has_many :topics
  has_many :notifies


  def mem_info
    MemInfo.find_by_mem_id(id) || MemInfo.create({:mem_id=> id})     
  end

  def avatar
    super.blank? ? 'default.png' : super
  end

  def avatar_url
    /^http.+\/\/.+$/.match(avatar).nil? ? "#{Rails.application.config.source_access_path}mem/#{avatar}" : avatar
  end

  def index
    Mem.where("id < ?",id).count + 1
  end
end
