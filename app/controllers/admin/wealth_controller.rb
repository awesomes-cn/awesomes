class Admin::WealthController < ApplicationController
  def save
    if params[:model] == 'code'
      Wealth.create({:})
    end
  end
end
