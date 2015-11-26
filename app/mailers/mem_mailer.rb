class MemMailer < ApplicationMailer
  def find_pwd item
    @item = item 
    mail(to: item[:to],subject:  "Awesomes-cn 找回密码")
  end
end
