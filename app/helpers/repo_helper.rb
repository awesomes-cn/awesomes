module RepoHelper
  def hometyp
    Menutyp.order("home_index desc").limit(10).offset(0)
  end

  def recommends
    Repo.order('recommend desc').limit(6).offset(0)
  end

  def fresh date
    _val = Time.now.to_i - date.to_i

    if _val > 2 * 30 * 24 * 3600
      return ['outdated', '过期']
    end

    if _val < 7 * 24 * 3600
      return ['often', '频繁']
    end

    return ['normal', '正常']

  end

  def trends repo
    repo.repo_trends.order('id desc').pluck('trend')[0..8].reverse.join(',')
  end

  def page_param
    _para = ['sort','tag','q', 'group'].select do |item|
      params[item.to_sym]
    end.map do |item|
      "#{item}=#{params[item.to_sym]}"
    end.join('&')
  end
end
