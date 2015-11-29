ActiveSupport::Notifications.subscribe "comment.create" do |*args|
  data = args.extract_options!
  _item = data[:item]
  if _item.typ == 'TOPIC'
    _topic = _item.target
    NotifyJob.new({
      :typcd=> 'COMMENT',
      :desc=> "[#{data[:mem].nc}](/mem/#{data[:mem].id}) 评论了你的文章 [#{_topic.title}](/topic/#{_topic.id})",
      :mem_id=> _topic.mem_id,
      :link=> "/topic/#{_item.idcd}"
    }).enqueue 
  end
end


ActiveSupport::Notifications.subscribe "oper.create" do |*args|
  data = args.extract_options!
  _item = data[:item]
  if _item.opertyp == 'FAVOR' and  _item.typ == 'TOPIC'
    _topic = _item.target
    NotifyJob.new({
      :typcd=> 'FAVOR',
      :desc=> "[#{data[:mem].nc}](/mem/#{data[:mem].id}) 赞了你的文章 [#{_topic.title}](/topic/#{_topic.id})",
      :mem_id=> _topic.mem_id,
      :link=> "/topic/#{_item.idcd}"
    }).enqueue 
  end
end
