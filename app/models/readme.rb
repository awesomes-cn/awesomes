class Readme < ActiveRecord::Base
  belongs_to :mem
  belongs_to :repo

  def friendly_time 
    created_at.friendly_i18n  
  end


  def status_alia
    {
      :UNREAD=> '待审核',
      :READED=> '已通过',
      :UNPASS=> '审核未通过'
    }[status.to_sym]
  end


  #计算字数统计
  def compute_contribute
    about.length - (old || '').length
  end
end
