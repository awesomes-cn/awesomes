class Repo < ActiveRecord::Base
  has_many :readmes
  has_many :repo_notifies
  has_many :repo_trends
  has_many :codes
  has_many :repo_trans_locks 

  attr_accessor :isusing

  include AlgoliaSearch
  algoliasearch auto_index: false, auto_remove: false, raise_on_failure: Rails.env.development?, force_utf8_encoding: true do
    attributes :name, :description, :description_cn, :typcd, :typcd_zh, :rootyp, :rootyp_zh, :stargazers_count, :tag, :hidetags, :typalia
    attributesToIndex ['name, description, description_cn, tag, hidetags, typcd , typcd_zh, rootyp, rootyp_zh, typalia']
    customRanking ['desc(stargazers_count)']
  end



  #searchkick batch_size: 20000


  after_create :after_create_callback

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

  def issue_friendly
    Time.at(Time.new.to_i - issue_res).friendly_i18n 
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
    _total = readmes.where({:status=> 'READED'}).order("id desc").pluck('contribute').reduce(:+)

    _result = {}
    readmes.where({:status=> 'READED'}).order("id desc").includes(:mem).all.each do |item|
      _result["mem#{item.mem.id}".to_sym] ||= {:mem=> item.mem, :contribute=> 0} 
      _result["mem#{item.mem.id}".to_sym][:contribute] += item.contribute
    end

    _index = 1
    _prevtotal = 0

    return _result.map do |k, v| 
      v[:per] = (v[:contribute]  * 100 / _total).to_i
      v[:per] = 100 - _prevtotal if _index == _result.length
      _prevtotal += v[:per]
      _index += 1
      v
    end.sort do |prevItem, nextItem| 
      nextItem[:per] <=> prevItem[:per]
    end
  end

  def cover
    super || 'default.jpg'
  end

  def cover_path
    "#{Rails.application.config.source_access_path}repo/#{cover}"
  end

  def overall
    stargazers_count + forks_count + subscribers_count
  end

  def update_trend
    _repo_trend = repo_trends.find_or_create_by({:date=> Date.today})
    _repo_trend.update_attributes({:overall=> overall})
    _trend_prev = repo_trends.order("id desc").second
    _trend = _trend_prev ? (overall - _trend_prev.overall) / (Date.today - _trend_prev.date)  : 0
   
    _repo_trend.update_attributes({:trend=> _trend})
    _latest_trends = repo_trends.order('id desc')[0..5].map{|item| item.trend}
    _latest_trend = _latest_trends.count > 0 ? _latest_trends.reduce(:+) * 1.00 / _latest_trends.count : 0
    update_attributes({:trend=> _latest_trend})
  end

  def update_comment
    _count = Comment.where({:typ=> 'REPOEXPERIENCE', :idcd=> id}).count
    update_attributes({
      :experience=> _count
    })
  end

  def up_typ_zh
    update_attributes({
      :rootyp_zh=>  Menutyp.menu_a(rootyp).sdesc,
      :typcd_zh=>  Menutyp.menu_b(typcd, rootyp).sdesc
    })
  end

  def default_code
    codes.where({:status=> 'ACTIVED'}).first
  end

  def demo_code
    Code.find_by_id(demo) || default_code
  end

  def description_i18
    (I18n.locale.to_s != 'en' and description_cn) ? description_cn : description
  end

  def typalia
    "#{(Menutyp.find_by_key typcd).alia} #{(Menutyp.find_by_key rootyp).alia}"
  end

  def lock_mem
    _lock = repo_trans_locks[0]
    _lock ? _lock.mem : nil
  end

  def can_be_lock? mem
    _lock = repo_trans_locks[0]
    if _lock
      _reset = Time.new - _lock.created_at
      if _reset >= 2 * 24 * 3600 
        unlock
        return  {status: true}
      end
    end

    if readmes[0] && readmes[0].status == 'UNREAD'
       return {status: false, code: 'HASUNREAD', tip: '当前库有未处理的中文翻译<br>稍等我们会尽快处理'} 
    end

    if lock_mem && lock_mem.id != mem.id
      return {status: false, code: 'OTHERLOCKED', tip: '当前库已经被其它小伙伴锁定编辑中<br>还有一大波其它库等着你翻译额'} 
    end

    locks = mem.repo_trans_locks.pluck('repo_id')
    if locks.count >= 3 and !locks.include? id
      return {status: false, code: 'IHAVENO',  tip: '你当前已锁定3个库，不能再锁定了<br>请先将已锁定的库编辑提交完成再锁定其它库'} 
    end


    return {status: true}
  end

  def lock mem 
    RepoTransLock.find_or_create_by({:mem_id=> mem.id, :repo_id=> id})
  end

  def unlock
    _lock = repo_trans_locks[0]
    _lock.destroy
  end

  
  
  private
  def after_create_callback
    ActionController::Base.new.expire_fragment %r{repo_list_.+}
  end
  

  
end
