module HomeHelper

  def root_menus
    @root_menus.map do |root|
      link_to switl(root.key, root.sdesc), "/repos/#{root.key}"
    end.join(content_tag(:span)).html_safe
  end

  def root_menus_with_icon
    @root_menus.map do |menu|
      link_to_content = build_menu_link_to_content menu
      link_to link_to_content, "/repos/#{menu.key}", class: "#{repo_active params[:root], menu.key, 'active'}"
    end.join(content_tag(:span)).html_safe
  end

  def sub_menus
    @sub_menus.map do |menu|
      link_to_content = build_menu_link_to_content menu
      link_to link_to_content,
              "/repos/#{menu.try :parent}/#{menu.try :key}",
              class: "#{repo_active params[:root], menu.parent, 'on'} #{repo_active params[:typ], menu.key, 'active'}",
              data: {root: menu.try(:parent)}

    end.join.html_safe
  end

  def build_menu_link_to_content menu
    i = content_tag :i, class: "fa #{menu.icon}" do
    end
    span = content_tag :span do
      switl(menu.key, menu.sdesc)
    end
     "#{i} #{span}".html_safe
  end

  def doc_list
    _order_by = 'id desc'
    if !(_search = params[:keyword]).blank?
      _where_search = "name like ?", "%#{_search}%"
    end
    @items = data_list(Doc.where(_where_search).order(_order_by))
    @count = Doc.where(_where_search).count
  end

  def menus_b
    if !(_typ = ((@repo and @repo.rootyp) || params[:root])).blank?
      return Menutyp.where({:typcd => 'B', :key => _typ}).first
    end
    return nil
  end

  def sources_list
    @items = data_list(Topic.where({:typcd => 'SOURCE', :state => '0'}).order('id desc')).includes(:mem)
    @count = Topic.where({:typcd => 'SOURCE'}).count
  end

  def sitemap
    Repo.order('id desc').all.map do |item|
      {
          :loc => Rails.application.config.base_url + "#{item.link_url}",
          :lastmod => item.updated_at,
          :changefreq => 'daily',
          :title => item.name,
          :tag => [item.name, Menutyp.current(item.typcd, item.rootyp).sdesc],
          :pubTime => item.created_at,
          :breadCrumb => [
              {:title => Menutyp.current(item.rootyp).sdesc, :url => Rails.application.config.base_url + "/repos/#{item.rootyp}"},
              {:title => Menutyp.current(item.typcd, item.rootyp).sdesc, :url => Rails.application.config.base_url + "/repos/#{item.rootyp}/#{item.typcd}"}
          ],
          :thumbnail => "#{access_path 'repo'}#{item.cover}"
      }
    end
  end

  def repo_active a, b, style
    a.to_s.downcase == b.to_s.downcase ? style : ''
  end
end
