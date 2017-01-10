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
  has_many :wealth_logs
  has_many :uses, -> {where(opertyp: 'USING', typ: 'REPO').order('opers.order asc')},
                  class_name: "Oper",
                  foreign_key: 'mem_id'
  has_many :usedrepos, through: :uses, source: 'use_repo'    
  has_many :repo_trans_locks        

  validates :nc,presence: true
  validates :nc,uniqueness: true


  def mem_info
    MemInfo.find_by_mem_id(id) || MemInfo.create({:mem_id=> id})     
  end

  def avatar_url
    avatar.blank? ? "http://svpa.awesomes.cn/avatar/#{nc}?size=100&font=kingthings" : (avatar[0..3] == 'http'  ? avatar  : "#{Rails.application.config.source_access_path}mem/#{avatar}")
  end

  def index
    Mem.where("id < ?",id).count + 1
  end

  def nc_for_avatar
    Pinyin.t(nc)
  end

  def auth_github
    mauths.where({:provider=> 'github'}).first
  end

  def update_oper opertyp, typ
    _count = Oper.where({:opertyp=> opertyp,:typ=> typ, :mem_id=> id}).count
    if opertyp == 'USING'
      update_attributes({:using=> _count})
    end
  end

  def lockedrepos
    repo_trans_locks.includes(:repo)
  end

end
