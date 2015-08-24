class ReadmeController < ApplicationController
  before_filter :readme_lost

  def new
    _repo = Repo.find(params[:rid])
  	Readme.create({:repo_id=> _repo.id,:about=> params[:markdown],:mem_id=> current_mem.id,:old=> _repo.about_zh,:sdesc=> params[:sdesc]}) 
  end

  def diff
    respond_to do |format|
      format.html{ 
      	render :layout=> "blank"
      }
      format.json { 
        @item.repo.update_attributes({:about_zh=> params[:markdown]})
        
        @item.status = "READED"
        @item.save
        
        redirect_to request.referer
      }
    end
  end

  def toggle 
    @item.status = (@item.status == "UNREAD" ? "READED" : "UNREAD") 
    @item.save
    redirect_to request.referer
  end
end
