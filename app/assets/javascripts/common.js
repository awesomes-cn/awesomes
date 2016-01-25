//上传文件uplaod_form
function uplaod_form($file,callback){
  $file.wrap('<div class="upwrap"></div>')
  $file.parent().append('<div class="upbtn"  data-loading-text="上传中...">'+$file.attr('data-text')+'</div>')
  var upbtn = $file.parent().find(".upbtn");
  $file.width(upbtn.css("width")).height(upbtn.css("height"));
  $file.change(function(){
    if($file.val() == ''){return false;}
    
    upbtn.button('loading');
    var upouter = $file.closest('.upwrap');

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
