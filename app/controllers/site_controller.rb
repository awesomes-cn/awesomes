class SiteController < ApplicationController
  @@client
	def translation
		render :layout=> 'application'
	end

  def test
    client = EvernoteOAuth::Client.new
    @@client = request_token = client.request_token(:oauth_callback => "#{request.protocol + request.host_with_port}/site/callback")
    redirect_to request_token.authorize_url
    
  end

  def callback
    #client = EvernoteOAuth::Client.new
    #request_token = client.request_token(:oauth_callback => "#{request.protocol + request.host_with_port}/site/callback")
    
    access_token = @@client.get_access_token(oauth_verifier: params[:oauth_verifier])
    token = access_token.token
    client = EvernoteOAuth::Client.new(token: token)
    note_store = client.note_store
    notebooks = note_store.listNotebooks(token)
    render json: notebooks
  end
end
