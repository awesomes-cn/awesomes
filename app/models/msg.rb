class Msg < ApplicationRecord
  def raw_con
    GitHub::Markdown.render con
  end

  def friendly_time
    created_at.friendly_i18n
  end

  def self.add_comment from, to, target_name, target_url
    return if from.id == to.id
    create({
      :con=> "[#{from.nc}](/mem/#{from.id}) 评论了 [#{target_name}](#{target_url})",
      :to=> to.id
    })
  end

  def self.add_comment_at from, to, target_name, target_url
    return if from.id == to.id
    create({
      :con=> "[#{from.nc}](/mem/#{from.id}) 在 [#{target_name}](#{target_url}) 中体提及到了你",
      :to=> to.id
    })
  end

  def self.add_comment_favor from, to, target_name, target_url
    return if from.id == to.id
    create({
      :con=> "[#{from.nc}](/mem/#{from.id}) 赞了你在 [#{target_name}](#{target_url}) 中的评论",
      :to=> to.id
    })
  end
end
