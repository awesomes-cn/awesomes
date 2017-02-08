module HomeControllerCommon
  extend ActiveSupport::Concern

  def assign_page_title
    typ_sdesc = Menutyp.find_by(key: params[:typ]).try :sdesc
    return typ_sdesc if typ_sdesc.present?
    root_typ_sdesc =  Menutyp.find_by(key: params[:root]).try :sdesc
    return root_typ_sdesc if root_typ_sdesc.present?
    '前端资源'
  end

end