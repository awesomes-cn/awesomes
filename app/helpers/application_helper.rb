module ApplicationHelper
  def access_path filepath
    "#{Rails.application.config.source_access_path}#{filepath}#{ENV['REPO_PIC_STYLE']}"
  end

  def is_login
    !session[:mem].nil?
  end

  def is_admin
    session[:mem] == 1
  end

  def switl en,zh
    @is_en? en : zh
  end

  def current_mem
    #if !session[:mem] and Rails.env == 'development'
    #  session[:mem] = 1
    #end
    Mem.find_by_id(session[:mem])  
  end

  def max_page_size
    100
  end
    
  def default_page_size
    15
  end

  def page_size
    size = params[:pagesize].to_i
    [size.zero? ? default_page_size : size, max_page_size].min
  end

  def page
    @page = params[:page]
    @page = 1 if !@page
    @page.to_i - 1
  end

  def data_list query,pagesize=page_size
    query.order('id desc').limit(pagesize).offset(page * pagesize)
  end

  def data_list_asc query
    query.order('id asc').limit(page_size).offset(page * page_size)
  end

  def url_all_para
    request.fullpath.downcase
  end

  def comment_list typ,idcd
    @comments = Comment.where({:typ=> typ,:idcd=> idcd})
  end

  def navon action
    params[:action] == action ? 'active' : ''
  end

  def encode(des_text)
    des = OpenSSL::Cipher::Cipher.new(ENV['ENCODE_ALG'])
    des.encrypt
    des.key = ENV['ENCODE_KEY']
    des.iv = ENV['ENCODE_IV']
    result = des.update(des_text)
    result << des.final
    return Base64.encode64 result
  end

  def decode(des_text)
    des = OpenSSL::Cipher::Cipher.new(ENV['ENCODE_ALG'])
    des.decrypt
    des.key = ENV['ENCODE_KEY']
    des.iv = ENV['ENCODE_IV']
    result = des.update(Base64.decode64 des_text)
    result << des.final
    return result
  end

  def enc_socket
    encode "#{session[:mem]}-#{Time.now.to_i}"
  end

end
