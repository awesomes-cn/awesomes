class AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_action :is_admin?

  def is_admin? 
    redirect_to "/" and return  if session[:mem] != 1
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
    @page =  @page.to_i - 1
  end

  def data_list query 
    query.order(params[:order_by]).order('id desc').limit(page_size).offset(page * page_size)
  end

  def data_list_asc query
    query.order('id asc').limit(page_size).offset(page * page_size)
  end

  def adminlists items,permits,jsonextra={}
    respond_to do |format|
      format.html
      format.json {
        
        _filter =  {}
        _fields = []
        if params[:filter]
          params[:filter].each do |key, value|
            _fields << key if value != ''
          end
          _filter = params.require(:filter).permit(_fields)
        end

        _reitems = items.select(permits+[:created_at,:id]).where(_filter)
        render json: {
          items: data_list(_reitems),
          count: items.where(_filter).count
        }.to_json(jsonextra)
      }
    end
  end 

  def clear_fragment key
    ActionController::Base.new.expire_fragment(key)
  end
 
 


end
