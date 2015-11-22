module MemHelper
  def gender_icon
    "fa-#{@mem.mem_info.gender.to_s.upcase == 'F' ? 'venus' : 'mars'}"
  end
end
