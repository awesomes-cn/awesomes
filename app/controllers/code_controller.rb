class CodeController < ApplicationController
  before_filter :code_lost, :except=> ['libs', 'libversions', 'libfiles'] 

  def code_lost
    @is_new = false
    @item = Code.find_by_id(params[:id])
    if !@item
      @repo = Repo.find_by_id(params[:rid]) 
      if @repo
        @item = @repo.default_code
      end

      if !@item
        @item = Code.new
        @item.mem = current_mem
        @item.title = "未命名"

        @is_author = !current_mem.nil?
        @is_new = true
      end
    else
      @repo = @item.repo
      @is_author = (current_mem and @item.mem_id == current_mem.id)
    end
    
  end

  def index
    if @repo
      @relateds = @repo.codes.where({:status=> 'ACTIVED'})
    end
  end

  def fork
    _item = @item.dup
    _item.mem_id = current_mem.id
    _item.status = 'NORMAL'
    _item.save
    if params[:typ] == 'new'
      _item.update_attributes({
        :js=> params[:js],
        :css=> params[:css],
        :html=> params[:html]
      })
    end
    render json: {status: true, id: _item.id}
  end

  def info
    @item.update_attributes({:title=> params[:title]})
    render json: {status: true}
  end

  def save
    render json: {status: false} and return if @item.mem_id != current_mem.id
    @item.update_attributes({
      :js=> params[:js],
      :css=> params[:css],
      :html=> params[:html]
    })

    if @is_new
      @item.update_attributes({:repo_id=> params[:rid], :title=> params[:title]})
    end
    

    render json: {status: true, id: @item.id}
  end

  def relate
    render json: {status: false} and return if @item.mem_id != current_mem.id
    _repo = params[:repo].split('/')
    @repo = Repo.find_by({:owner=> _repo[0], :alia=> _repo[1]})
    if @repo
      @item.update_attributes({:repo_id=> @repo.id})
    end
    render json: {status: !@repo.nil?}
  end

  def libs
    _packages = sub_directories "#{Rails.root.to_s}/public/sandbox/"
    _items = _packages.select{|item|
      item.start_with?(params[:libkey]) 
    }.map{|item|
      {name: item, versions: []}
    }
    render json: {items: _items[0..50]}  
  end

  def libversions
    _packages = sub_directories  "#{Rails.root.to_s}/public/sandbox/#{params[:lib]}/"
    _items = _packages.map { |item|
      {name: item, files: []}
    }
    render json: {items: _items}  
  end

  def libfiles
    _packages = sub_files  "#{Rails.root.to_s}/public/sandbox/#{params[:lib]}/#{params[:v]}/"
    render json: {items: _packages}  
  end

  def preview
    render :layout=> nil
  end
end
