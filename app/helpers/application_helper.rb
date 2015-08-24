module ApplicationHelper
  def access_path folder
    "#{Rails.application.config.source_access_path}#{folder}/"
  end

  def is_login
    !session[:mem].nil?
  end

  def is_admin
    session[:mem] == 1
  end

  def current_mem
    if !session[:mem] and Rails.env == 'development'
      session[:mem] = 1
    end
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
end
