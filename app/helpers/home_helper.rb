module HomeHelper
  def doc_list
    _order_by = 'id desc'
    if !(_search = params[:keyword]).blank?
      _where_search = "name like ?","%#{_search}%"
    end
    @items = data_list(Doc.where(_where_search).order(_order_by))
    @count = Doc.where(_where_search).count
  end

  def repo_list
    _order_by = '(stargazers_count+forks_count+subscribers_count) desc'
    _where = {}
    
    #if !(_typ = params[:typ]).blank? and (_menu = Menutyp.find_by_key(_typ))
    #  if _menu.parent
    #    _where = {:typcd=> _typ}
    #  else
    #    _where = {:typcd=> (_menu.subitem.pluck('key') << _typ)}
    #  end
    #end

    if !(_root = params[:root]).blank?
      _where = {:rootyp=> _root}
    end

    if !(_typ = params[:typ]).blank?
      _where = _where.merge({:typcd=> _typ})
    end

    if !(_search = params[:keyword]).blank?
      _where_search = "name like ?","%#{_search}%"
    end

    @items = data_list(Repo.where(_where).where(_where_search).order(_order_by))
    @count = Repo.where(_where).where(_where_search).count
    @root = Menutyp.find_by_key params[:root]
    @typ = Menutyp.find_by_key params[:typ]
  end

  def menus_b
    if !(_typ = ( (@repo and @repo.rootyp) || params[:root])).blank?
      return Menutyp.where({:typcd=>'B',:key=> _typ}).first
    end
    return nil
  end

  def sitemap 
    Repo.order('id desc').all.map do |item|
      {
        :loc => Rails.application.config.base_url + "#{item.link_url}",
        :lastmod => item.updated_at,
        :changefreq => 'daily',
        :title =>item.name,
        :tag => [item.name,(Menutyp.current item.typcd).sdesc],
        :pubTime => item.created_at,
        :breadCrumb =>[
          {:title=>(Menutyp.current item.rootyp).sdesc,:url=>Rails.application.config.base_url + "/repos/#{item.rootyp}"},
          {:title=>(Menutyp.current item.typcd).sdesc,:url=>Rails.application.config.base_url + "/repos/#{item.rootyp}/#{item.typcd}"}
        ],
      }
    end
  end
end
