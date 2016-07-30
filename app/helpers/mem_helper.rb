module MemHelper
  def gender_icon
    "fa-#{@mem.mem_info.gender.to_s.upcase == 'F' ? 'venus' : 'mars'}"
  end

  def role_alia mem
    {
      :user=> '普通会员',
      :vip=> '高级会员'
    }[mem.role.to_sym]
  end
end
