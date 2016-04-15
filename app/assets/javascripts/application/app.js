$(function(){
  $(".open-login").click(function(){
    return open_login();
  })

  $(".close-modal").click(function(){
    $(this).closest('.modal-wraper').animate({top: '-100%'}, function(){
      $(this).hide()
    })
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

  // 打开弹框
  $(".open-login-modal").click(function(){
    if(open_login()){
      $('.modal-wraper[data-modal=' + $(this).attr('data-modal') + ']').show().animate({top: 0})
    }
  })
  
})



function open_login(){
  if (!Rails.islogin) {
    //window.location.href="/login"
    $('.login-wraper').show().animate({top: 0})
    return false
  }else{
    return true;
  }
}

function close_login(){
  $('.login-wraper').animate({top: '-100%'}, function(){
    $(this).hide()
  })
}


// 关闭弹框
function closeModal(ele){
  $('.modal-wraper').animate({top: '-100%'}, function(){
    $(this).hide()
  })
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
