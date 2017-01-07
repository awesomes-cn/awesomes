//上传文件uplaod_form
function uplaod_form($file,callback){
  $file.wrap('<div class="upwrap"></div>')
  $file.parent().append('<div class="upbtn"  data-loading-text="上传中...">'+$file.attr('data-text')+'</div>')
  var upbtn = $file.parent().find(".upbtn");
  $file.width(upbtn.css("width")).height(upbtn.css("height"));
  upload_change($file, upbtn, null, callback)
}


function uplaod_form_by_wraper($wraper,callback){
  var $file = $('<input type="file"  name="filedata" data-post="' + $wraper.attr('data-post') + '" data-folder="' + $wraper.attr('data-folder') + '"/>')
  $file.width($wraper.css("width")).height($wraper.css("height"));
  $wraper.append($file)
  upload_change($file, null, $wraper, callback)
}


function upload_change($file, upbtn, $wraper) {
  $file.change(function(){
    if($file.val() == ''){return false;}
    if(upbtn) {
      upbtn.button('loading');  
    }
    var upouter = $wraper || $file.closest('.upwrap');

    upouter.wrap("<form class='uploadform' method='post' enctype='multipart/form-data' action='" + $file.attr('data-post') + "'></form>");


    var _width = $file.attr('data-width');
    var _height = $file.attr('data-height');
    var whinput = "";
    if(_width && _height){
      whinput = "<input type='hidden' name='width' value='"+_width+"'/><input type='hidden' name='height' value='"+_height+"'/>";
    }

    var fol = $('<input type="hidden" name="folder" value="'+ $file.attr('data-folder') + '" />' + whinput)
    upouter.append(fol)

    upouter.parent().ajaxSubmit(function(data){
      upouter.unwrap();
      fol.remove();
      data  = $.parseJSON(data);
      if(data.status){
        $(upouter.attr('data-for')).val(data.url);
        if(callback){callback(data)}
      }else{
      }
      upbtn.button('reset');
    });
  });
}




//- 折线图
function draw_line($ele,data,wraper_w,wraper_h,color,stroke){
  var postion_x = 0,
    max = _.max(data),
    scale_y = parseInt(wraper_h / max) + 1,
    step_x = parseInt(wraper_w / (data.length - 1)) + 1,
    path = "M0 " + wraper_h + " "
    path += " L0 " + (max - data[0]) * scale_y  + " "; 
  for(var i = 1; i < data.length ; i++ ){
    postion_x += step_x;

    path += " L" + postion_x + " " + (max - data[i]) * scale_y   + " "; 
  }
  path += " L" + postion_x + " " + max * scale_y + " ";
  console.log(path)
  $ele.html("<svg height='"+ wraper_h +"px' width='"+wraper_w+"px'><path d='" + path + " Z' fill='"+color+ "' stroke='"+stroke+"'></path></svg>")
}

//- 打開登陸
function third_login(url){
  window.open(url, 'newwindow', 'width=500,height=500');
}


function lazyLoadPic(){
  $("img.lazy").lazyload({
    placeholder: '/assets/placeholder.png'
  });
}
