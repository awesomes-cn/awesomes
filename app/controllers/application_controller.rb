class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    #session[:mem] = 158
    _local = params[:l] || request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
    I18n.locale = (@is_en = _local == 'en') ? 'en' : 'zh-CN'
  end


  def current_mem
    Mem.find_by_id(session[:mem])
  end

  def admin_login
    #true
    redirect_to root_path and return if session[:mem] != 1
  end

  def mem_login
    #true
    redirect_to "/login" and return if !current_mem
  end

  def is_me?
    _id = params[:id].to_i
    if _id > 0
      @mem = Mem.find_by_id _id
      redirect_to '/tip',:notice=> t('mem_none') and return if !@mem
    else
      redirect_to '/tip',:notice=> t('no_login') and return  if session[:mem].to_i < 1
      @mem = current_mem
    end

    #redirect_to '/tip',:notice=> t('mem_novalid') and return if @mem.recsts == '1'
    @isme = (@mem == current_mem)
  end

  def is_admin?
    redirect_to "/" and return  if session[:mem] != 1
  end

  def force_me
    if session[:mem] != 1
      @mem = current_mem
    end
  end

  def max_page_size
    100
  end

  def default_page_size
    14
  end

  def page_size
    size = params[:pagesize].to_i
    [size.zero? ? default_page_size : size, max_page_size].min
  end

  def page
    @page = params[:page]
    @page = 1 if !@page
    @page =  @page.to_i - 1
  end

  def data_list query, pagesize = page_size
    query.order('id desc').limit(pagesize).offset(page * pagesize)
  end

  def data_list_asc query, pagesize = page_size
    query.order('id asc').limit(pagesize).offset(page * pagesize)
  end

  def upload_pic(file,filename,folder,width,height)
    _full_path = "#{Rails.root}/public/upload/#{folder}/#{filename}"
    image = MiniMagick::Image.read(file)
    if width.to_i > 0 and height.to_i > 0
      _width = image[:width]
      _height = image[:height]
      _x = 0
      _y = 0
      if width / height > _width / _height
        image.resize "#{width}x"
        _y = ((image[:height] - height) / 3.0 * 2).to_i
      else
        image.resize "x#{height}"
        _x = ((image[:width] - width) / 2.0).to_i
      end
      image.crop "#{width}x#{height}+#{_x}+#{_y}"
    end
    image.write  _full_path
    FileUtils.chmod 0755, _full_path
    aliyun_upload _full_path,"#{folder}/#{filename}"
  end

  def aliyun_upload file,target
    require 'aliyun/oss'
    client = Aliyun::OSS::Client.new(
      :endpoint => ENV['OSS_END_POINT'],
      :access_key_id => ENV['OSS_ACCESS_ID'],
      :access_key_secret => ENV['OSS_ACCESS_KEY'])
    bucket = client.get_bucket(ENV['OSS_BUCKET'])
    bucket.put_object(target, :file => file)
  end

  def upload_remote(remote_src,filename,folder)
    _full_path = "#{Rails.root}/public/upload/#{folder}/#{filename}"
    require 'open-uri'
    open(remote_src) {|f|
      File.open(_full_path,"wb") do |file|
        file.puts f.read
      end
    }

    aliyun_upload File.open(_full_path),"#{folder}/#{filename}"
  end

  def clear_fragment key
    ActionController::Base.new.expire_fragment(key)
  end

  def encode(str)
    des = OpenSSL::Cipher::Cipher.new(ENV['ENCODE_ALG'])
    des.pkcs5_keyivgen(ENV['ENCODE_KEY'],  ENV['ENCODE_DES_KEY'])
    des.encrypt
    cipher = des.update(str)
    cipher << des.final
    return Base64.encode64(cipher) #Base64编码，才能保存到数据库  
  end

  def decode(str)
    str = Base64.decode64(str)
    des = OpenSSL::Cipher::Cipher.new(ENV['ENCODE_ALG'])
    des.pkcs5_keyivgen(ENV['ENCODE_KEY'],  ENV['ENCODE_DES_KEY'])
    des.decrypt
    des.update(str) + des.final
  end

  def sub_directories path
    require 'find'
    Dir.chdir path
    Dir["*"].reject{|o| not File.directory?(o)}
  end

  def sub_files path
    require 'find'
    Dir.chdir path
    Dir.glob("*.*")
  end

end
