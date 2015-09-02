class Repo < ActiveRecord::Base
  has_many :readmes
  has_many :repo_notifies

  after_create do |item|
    ActionController::Base.new.expire_fragment  %r{repo_list_.+} 
  end

  after_destroy do |item|
    ActionController::Base.new.expire_fragment  %r{repo_list_.+} 
  end

  after_update do |item|
    ActionController::Base.new.expire_fragment "repo_en_view_#{item.id}"
    ActionController::Base.new.expire_fragment "repo_zh_view_#{item.id}"
  end

  def link_url
    "/repo/#{owner}/#{alia}"
  end
  
  def friendly_time 
    pushed_at.friendly_i18n  
  end

  def readme_contributors
    Mem.where({:id=> readmes.pluck("mem_id")})
  end

  def update_typ_num
    _typ = Menutyp.find_by({:key=> typcd,:parent=> rootyp})
    _typ.num = Repo.where({:typcd=> typcd,:rootyp=> rootyp}).count
    _typ.save
  end

  def contributors
    _mems = readmes.where({:status=> 'READED'}).order("id desc").pluck("mem_id")
    Mem.find(_mems)
  end
end
