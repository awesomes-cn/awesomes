class SourceController < ApplicationController
  before_filter :source_lost

  def source_lost 
    @item = Topic.find_by_id(params[:id])
  end

  

end
