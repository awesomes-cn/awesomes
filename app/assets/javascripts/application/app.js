$(function(){
  $(".open-login").click(function(){
    return open_login();
  })
  $("pre").each(function(){
    var pre = $(this);
    var _lang = pre.attr('lang');
    if(_lang == 'html'){
      _lang = "markup";
    }
    pre.find('code').attr('class',"language-"+_lang);
  })
  Prism.highlightAll();
  
  $("article table").each(function(){
    $(this).attr('class','table');
  })
})

//Turbolinks.enableProgressBar();
Turbolinks.pagesCached(0); 

$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });

function open_login(){
  if (!Rails.islogin) {
    window.location.href="/login"
  }else{
    return true;
  }
}


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


function list_data($scope,$http,list_url,$scopeitems,$pagnation,callback){
  var me =  function(page,pagesize,id,paras){
    var data_page = $scope[$scopeitems + 'page'];
    if(!page || page == 0) {
      if(!data_page) {
        page = 1;
      }else {
        page = data_page;
      };
    };
    $scope[$scopeitems + 'page'] = page;
    var curl = list_url;
    if(id){
      curl = list_url.replace(/(.+)\//g,'$1/'+ id +'/');
    }
    var params = {page: page,pagesize: pagesize}
    if(paras){
      params = _.extend(params,paras)
    }
    $http.get(curl,{params: params}).success(function(data){
      if(callback){data=callback(data)}
      $scope[$scopeitems] = data.items;
      if ($pagnation) {
        $pagnation.next('h3.nodata').remove();
        if(data.count > 0) {
          $pagnation.pagination(data.count,{
            items_per_page : pagesize,
            current_page : page-1,
            prev_text:'>',
            next_text:'<',
            callback : function(cpage){
              me(cpage + 1,pagesize,id,paras)
              return false;
            }
          })
          $pagnation.show()
        }else{
          var no_data = $pagnation.attr('暂时没有数据');
          $("<h3 class='nodata'>" + no_data + "</h3>").insertAfter($pagnation);
          $pagnation.hide()
          $('h3.nodata').show()
        }
      }
    })
  }
  return me
}
