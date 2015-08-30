module RepoHelper
  def hometyp
    Menutyp.order("home_index desc").limit(10).offset(0)
  end
end
