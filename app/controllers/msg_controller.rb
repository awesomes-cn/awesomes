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
end
