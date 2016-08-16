module HomeOtherAction
  extend ActiveSupport::Concern

  def docs
    render :layout => nil
  end

  def markdown
    @item = Site.find_by({:typ => 'MARKDOWN'}) || Site.create({:typ => 'MARKDOWN'})
    respond_to do |format|
      format.html {
      }
      format.json {
        @item.update_attributes({:fdesc => params[:markdown]})
        redirect_to request.referer
      }
    end
  end

  def sitemap
    respond_to do |format|
      format.html {
        render text: 'please visit .xml page' and return
      }
      format.xml {
        render :layout => nil
      }
      format.txt {
        render :layout => nil
      }
    end

  end

  def test
    #render json: Repo.search("apples", limit: 10, offset: 0).total_count
  end

  def find_pwd
    respond_to do |format|
      format.html {

      }
      format.json {
        _email = params[:email]
        _str = encode("#{_email}-#{Time.new.to_i}")
        _url = "#{ENV["BASE_URL"]}pwd_reset?key=#{_str}"
        MemMailer.find_pwd({:to => _email, :url => _url}).deliver
        redirect_to request.referer, :notice => 'OK'
      }
    end
  end

  def pwd_reset
    respond_to do |format|
      format.html {
        redirect_to '/tip', :notice => '链接失效，请重新获取' and return if params[:key].blank?
        _key = decode(params[:key]).split('-')
        redirect_to '/tip', :notice => '链接失效，请重新获取' and return if Time.new.to_i - _key[1].to_i > 3600
      }
      format.json {
        _key = decode(params[:key]).split('-')
        redirect_to request.referer, :notice => '邮箱错误或链接无失效' and return if _key[0] != params[:email] or Time.new.to_i - _key[1].to_i > 3600
        _mem = Mem.find_by_email(_key[0])
        _pwd = Digest::MD5.hexdigest params[:pwd]
        redirect_to request.referer, :notice => '当前邮箱尚未注册' and return if !_mem
        _mem.update_attributes({:pwd => _pwd})
        redirect_to '/tip', :notice => '密码重置成功，马上登陆吧' and return
      }
    end
  end

  def rss
    _items = Repo.order(id: :desc).limit(10)
    @items = _items.map do |item|
      _root = Menutyp.menu_a item.rootyp
      _typ = Menutyp.menu_b item.typcd, item.rootyp
      {
          :title => "#{item.name}",
          :author => item.owner,
          :link => "#{Rails.application.config.base_url}repo/#{item.owner}/#{item.alia}",
          :date => item.created_at,
          :desc => item.description,
          :categories => "#{item.rootyp_zh}-#{item.typcd_zh}"
      }
    end.uniq[0...10]
    respond_to do |format|
      format.html
      format.xml { render :layout => nil }
    end
  end

end
