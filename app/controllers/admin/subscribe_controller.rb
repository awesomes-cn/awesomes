class Admin::SubscribeController < AdminController
  def export
    emails = Subscribe.all.map do |item|
      item.email
    end
    send_data emails.join(','), filename: 'email.txt'
  end

  def destroy
    Subscribe.find_by_id(params[:id]).destroy
    render json: {status: true}
  end

  def empty
    render json: {status: true}
    Subscribe.all.each do |item|
      item.destroy
    end
    render json: {status: true}
  end
end
