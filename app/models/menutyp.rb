class Menutyp < ActiveRecord::Base

  scope :root_menus, -> { where typcd: :A, group: :REPO}
  scope :sub_menus, -> { where typcd: :B,  group: :REPO }

  @@CACHE_KEY="MENUTYP"

  def self.current(key,parent='')
    Rails.cache.write(@@CACHE_KEY, Menutyp.all) if Rails.cache.read(@@CACHE_KEY).nil?
    Rails.cache.read(@@CACHE_KEY).find_all{|r|r.key == key and r.parent == parent}.first || Menutyp.new
  end

  def link
    parent ? "/repos/#{parent}/#{key}" : "/repos/#{key}"
  end

  def self.menu_a key
    Menutyp.find_by({:key=> key, :parent=> '', :group=> 'REPO'})
  end

  def self.menu_b key,parent
    Menutyp.find_by({:key=> key, :parent=> parent})
  end

  def self.menus typcd
    Menutyp.where({:typcd=> typcd, :group=> 'REPO'}).all
  end

  def self.menusc par
    Menutyp.where({:typcd=> 'C',:parent=> par}).all
  end

  def subitems_c
    Menutyp.order('`key`').where({:parent=> key,:typcd=> 'C'}).all
  end

  def subitems_b
    Menutyp.where({:parent=> key,:typcd=> 'B'}).all
  end

  def superior
    Menutyp.find_by_key parent
  end

  def self.flat_show
    sub_menus.find_each.map do |item|
      {
        :key=>"#{item.parent}-#{item.key}",
        :sdesc=>"#{item.parent ? item.superior.sdesc + ' - ' : ''}#{item.sdesc}"
      }
    end
  end

  def self.api_all
    sub_menus.find_each.map do |item|
      {
        :id=> item.id,
        :typcd=> item.key,
        :rootyp=>  item.parent,
        :typcd_zh=> item.sdesc,
        :rootyp_zh => item.superior.sdesc
      }
    end
  end

  def self.home root
    (_item = Menutyp.where({:key=> root,:typcd=> 'B'}).first).nil? ? '' : _item.home
  end
end
