class SessionsController < ApplicationController
  def create
    respond_to do |format|
      format.html {
        session[:login_callback] = request.referer
      }
      format.json {
        _pwd = Digest::MD5.hexdigest params[:pwd]
        _mem = Mem.find_by({:email => params[:email]})

        #登陆
        if _mem
          #redirect_to request.referer,:notice=> t('tip.pwd_error') and return if _mem.pwd != _pwd
          render json: {status: false, notice: t('tip.pwd_error')} and return if _mem.pwd != _pwd
        else
          _mem = Mem.create({:email => params[:email], :pwd => _pwd, :nc => params[:nc].strip})
          #redirect_to request.referer,:notice=> _mem.errors.messages.values.flatten.join("，") and return if _mem.invalid?
          render json: {status: false, notice: _mem.errors.messages.values.flatten.join("，")} and return if _mem.invalid?
        end

        session[:mem] = _mem.id
        #redirect_to session[:login_callback] || '/mem'
        render json: {
            status: true,
            login: {
                status: true
            }

        }
      }
    end

  end

  def destroy
    session['mem'] = nil
    redirect_to request.referer
  end
end
