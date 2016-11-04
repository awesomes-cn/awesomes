class MemMailer < ApplicationMailer
  def find_pwd item
    @item = item 
    mail(to: item[:to],subject:  "Awesomes-cn 找回密码")
  end

  def promotion email
    mail(to: email, subject:  "Awesomes-cn 致前端开发者的一封信")
  end
end
