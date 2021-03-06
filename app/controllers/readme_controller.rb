class ReadmeController < ApplicationController
  before_action :readme_lost
  before_action :admin_login,:only=> ["toggle","unpass"]

  def readme_lost
    @item = Readme.find_by_id(params[:id]) 
  end
  
  def new
    _repo = Repo.find(params[:rid])
    render json: false and return if !(_repo.can_be_lock? current_mem)[:status]
    
  	Readme.create({:repo_id=> _repo.id,:about=> params[:markdown],:mem_id=> current_mem.id,:old=> _repo.about_zh,:sdesc=> params[:sdesc]}) 
    render json: true
  end

  def diff
    respond_to do |format|
      format.html{ 
      	render :layout=> "blank"
      }
      format.json { 
        @item.repo.update_attributes({:about_zh=> params[:markdown]})
        @item.contribute = params[:contribute]
        @item.status = "READED"
        @item.save
        
        redirect_to '/admin/readmes'
      }
    end
  end

  def toggle 
    @item.status = (@item.status == "UNREAD" ? "READED" : "UNREAD") 
    @item.save
    redirect_to request.referer
  end

  def unpass
    @item.status = 'UNPASS'
    @item.save
    redirect_to request.referer
  end

end
