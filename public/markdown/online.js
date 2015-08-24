$(function(){
  //横向拖动
  $('.markdown-wraper .spliter').mousedown(function(eve){
    //reset_max_width(eve);
    var split_obj = $(this);
    var prev_ele = split_obj.prev('.preview-wraper');
    var next_ele = split_obj.next('.editor-wraper');
    var split_obj_left = parseInt(split_obj.css('left'));
    current_position = eve.clientX;
    prev_width = prev_ele.width();
    next_width = next_ele.width();
    next_left = parseInt(next_ele.css('left'));

    $('body').mousemove(function(e){ 
      if (next_width - e.clientX + current_position <= 100) {
        return false;
      };
      prev_ele.width(prev_width + e.clientX - current_position);
      next_ele.width(next_width - prev_ele.width() + prev_width).css('left',next_left + prev_ele.width() - prev_width);
      ajust_split(split_obj);

    })

  });
  
  $('body').mouseup(function(){
    $('body').unbind('mousemove');
    $('.widnow-cover').hide();
  })
})


function ajust_split(obj){
  obj.css('left',(obj.prev().width() + parseInt(obj.prev().css('left'))));
}
