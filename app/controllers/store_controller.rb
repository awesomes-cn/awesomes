class StoreController < ApplicationController
  def goods
    respond_to do |format|
      format.html{
      }
      format.json {
        render json: {
          :items=> Good.all
        }
      }
    end
  end

  def exchange
    
  end
end
