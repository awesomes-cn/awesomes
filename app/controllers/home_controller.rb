class HomeController < ApplicationController
  before_filter :admin_login,:only=> ["trend"]
  def repos
    @typ = Menutyp.where({:key=> params[:root],:typcd=> 'B'}).first
    render :layout=> nil
  end
  
  def docs
  	render :layout=> nil
  end

  def markdown
  	@item =  Site.find_by({:typ=> 'MARKDOWN'}) || Site.create({:typ=> 'MARKDOWN'})
  	respond_to do |format|
      format.html{  
      }
      format.json { 
      	@item.update_attributes({:fdesc=> params[:markdown]})
        redirect_to request.referer
      }
    end
  end

  def sitemap 
    respond_to do |format|
      format.html {
        render text: "please visit .xml page" and return
      }
      format.xml {
        render :layout =>nil
      }
      format.txt {
        render :layout =>nil
      }
    end

  end

  def test
    respond_to do |format|
      format.html{}
      format.json{
        require 'rest-client'
        _response = RestClient.post 'http://192.168.0.103:8080/tip?name=hxh', {:mem=> 1}
        render json: true
      }
    end
  end


  
end
