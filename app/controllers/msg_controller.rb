class MsgController < ApplicationController
  def weuseapply
    Msg.create({
      :level=> 'admin',
      :typ=> 'weuseapply',
      :from=> current_mem.id,
      :con=> params[:reason]
    })

    render json: true
  end


  def markread
    Msg.where(['id in (?)', params[:ids]]).update_all(status: 'READED')
    render json: {status: true}
  end
end
