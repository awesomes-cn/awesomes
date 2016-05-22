JS_VOID = 'javascript:void(0)'
module ApplicationHelper
  def access_path filepath
    "#{Rails.application.config.source_access_path}#{filepath}"
  end
  
  def repo_cover_base cover
    "#{Rails.application.config.source_access_path}repo/#{cover}"
  end

  def repo_cover_path cover
    "#{repo_cover_base(cover)}#{ENV['REPO_PIC_STYLE']}"
  end

  def subject_cover_path cover
    "#{Rails.application.config.source_access_path}subject/#{cover}"
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

  def login_status
    _mem = {nc: nil, id: nil}
    if is_login
      _mem = {
        nc: current_mem.nc,
        id: current_mem.id
      }
    end
    {
      status: is_login,
      mem: _mem
    }
  end

  

end
