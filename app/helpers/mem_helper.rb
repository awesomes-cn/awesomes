module MemHelper
  def gender_icon
    "fa-#{@mem.mem_info.gender.to_s.upcase == 'F' ? 'venus' : 'mars'}"
  end

  def role_alia mem
    {
      :user=> t('role.member'),
      :vip=> t('role.senior')
    }[mem.role.to_sym]
  end

  def readme_status_label status
    {
      :UNREAD=> 'default',
      :READED=> 'success',
      :UNPASS=> 'danger'
    }[status.to_sym]
  end
end
