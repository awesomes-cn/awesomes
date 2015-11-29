class NotifyController < ApplicationController
  before_filter :notify_lost

  def notify_lost
   @item = Notify.find_by_id(params[:id])
  end

  def index 
    
  end


end
