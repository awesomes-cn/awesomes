module CodeHelper
  def is_code_author
    is_login and current_mem.id == @item.mem.id
  end
end
