class SubmitController < ApplicationController
  def save
    @repo = Repo.find_by_html_url(params[:html_url])
    _typ = params[:typ].split("-")
    Submit.create({:html_url=> params[:html_url],:typcd=> _typ[1..-1].join("-"),:rootyp=> _typ[0]}) if !@repo
  end
end
