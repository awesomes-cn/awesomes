class Mem < ActiveRecord::Base
  include LetterAvatar::AvatarHelper
  has_many :readmes
  has_many :mauths
  has_one :mem_info
  has_many :comments
  has_many :mem_repos
  has_many :topics
  has_one :mem_rank
  has_many :codes
  has_many :uses,  -> { where opertyp: 'USING', typ: 'REPO'},
                  class_name: "Oper",
                  foreign_key: 'mem_id'
  has_many :usedrepos, through: :uses, source: 'use_repo'            

  validates :nc,:email,:pwd,presence: true
  validates :nc,:email, uniqueness: true


  def mem_info
    MemInfo.find_by_mem_id(id) || MemInfo.create({:mem_id=> id})     
  end

  def avatar_url
    avatar.blank? ? "http://svpa.awesomes.cn/avatar/#{nc}?size=100&font=kingthings" : "#{Rails.application.config.source_access_path}mem/#{avatar}"
  end

  def index
    Mem.where("id < ?",id).count + 1
  end

  def nc_for_avatar
    Pinyin.t(nc)
  end

end
