var editorVue,htmlCodeMirror, jsCodeMirror, cssCodeMirror;

$(function(){
  editorVue = initEditor('#code-wraper')

  $('body').mouseup(function(){
    $('body').unbind('mousemove')
    $('.window-cover').hide()
  })

  initCodeMirror()

})



function initEditor(id){
  console.log(localStorage.autoruncode)
  var editor = new Vue({
    el: id,
    data: {
      p1: {w: 0, h: 100, ow: 0, oh: 0},
      p2: {w: 0, h: 100, ow: 0},
      p3: {w: 0, h: 100, ow: 0},
      p4: {h: 100, oh: 0},
      ox: 0,
      oy: 0,
      left: {w: 200, ow: 200, state: 'fold'},
      right: {w: 200, ow: 200, state: 'fold'},
      isauto: localStorage.autoruncode || 'false',
      login: Rails.login,
      issaved: true,
      libs: [],
      libkey: '',
      toolboxState: 'closed'

    }
  })

  
  // 初始化
  var editareaw = $(id).find('.code-editor').width()

  var editareah = $(id).find('.code-editor').height()
  
  var basew = parseInt(editareaw / 3)
  var baseh = parseInt((editareah - 40) * 0.4)
  editor.p1.w = basew + 'px'
  editor.p1.h = baseh + 'px'
  editor.p2.w = basew + 'px'
  editor.p3.w = (editareaw - basew * 2 - 5 * 2) + 'px'
  editor.p4.h = ((editareah - 40) - baseh - 5) + 'px'


  
  // 横向移动
  editor.moveX = function(e, pleft, pright){
    editor.ox = e.clientX
    pleft.ow = pleft.w
    pright.ow = pright.w
    $('body').mousemove(function(me){
      var diff = me.clientX - editor.ox
      var leftw = parseInt(pleft.ow) + diff
      var rightw = parseInt(pright.ow) - diff
      if (leftw <= 50 || rightw <= 50) {return}
      pleft.w = leftw + 'px'
      pright.w = rightw  + 'px'
    })
  }

  // 纵向移动
  editor.moveY = function(e){
    $('.window-cover').show()
    var ptop = editor.p1
    var pbottom = editor.p4

    editor.oy = e.clientY
    ptop.oh = ptop.h
    pbottom.oh = pbottom.h
    $('body').mousemove(function(me){
      var diff = me.clientY - editor.oy
      var toph = parseInt(ptop.oh) + diff
      var bottomh = parseInt(pbottom.oh) - diff
      if (toph <= 50 || bottomh <= 50) {return}
      ptop.h = toph + 'px'
      pbottom.h = bottomh + 'px'
    })
  }
   
  // 预览
  editor.preview = function(){
    run_code()
  }
  

  // 切换侧栏 折叠 / 展开  
  editor.switchSideBar = function(bar, direction){
    var field = direction == 'left' ? editor.left : editor.right
    if(field.state == 'ing') return 

    var outer = $(bar)
    var relatep = direction == 'left' ? editor.p1 : editor.p3

    
    var param = {
      // 折叠
      fold: {
        distance: field.w, 
        state: 'open'

      },
      // 展开
      open: {
        distance: - field.w, 
        state: 'fold'

      },
    }[field.state] 


    var distance = param.distance
    if (field.state == 'open') {
      relatep.w = parseInt(relatep.w) + distance + 'px' 
    }else{
      outer.find('.inner-out').fadeOut()
    }
    field.state = 'ing'
    
    outer.animate({width: '-=' + distance})
    var ani = direction == 'left' ? {paddingLeft: '-=' + distance} : {paddingRight: '-=' + distance}
    $(id).animate(ani, function(){ 
      field.state = param.state
      if (field.state == 'open') {
        relatep.w = parseInt(relatep.w) + distance + 'px'
      }else{
        outer.find('.inner-out').fadeIn()
      }
    })
   
  }

  editor.openBar = function(){
   editor.toolboxState = 'ing'
    $('#toolbox').animate({right: 1}, function(){
      editor.toolboxState = 'open'
    })
  }
  editor.closeBar = function(){
    editor.toolboxState = 'ing'
    $('#toolbox').animate({right: -200}, function(){
      editor.toolboxState = 'closed'
    })
  }
  editor.switchBar = function(action){
    if (editor.toolboxState == 'closed') {
      editor.openBar()
    }else if(editor.toolboxState == 'open'){
      editor.closeBar()
    }
  }


  
  


  // 切换自动运行
  editor.switchAuto = function(){
    editor.isauto = (editor.isauto == 'true' ? 'false' : 'true') ;
    localStorage.autoruncode = editor.isauto
  }

  editor.fork = function(typ){
    if(open_login()){
      $.post('/code/fork', {
        id: itemid,
        css: cssCodeMirror.getValue(),
        js: jsCodeMirror.getValue(),
        html: htmlCodeMirror.getValue(),
        typ: typ
      }, function(data) {
        if (data.status) {
          window.location.href="/code/" + data.id
        }
      })
    }
  }

  
  // 保存
  editor.save = function(){
    $.post("/code/save", {
      css: cssCodeMirror.getValue(),
      js: jsCodeMirror.getValue(),
      html: htmlCodeMirror.getValue(),
      id: itemid,
      rid: rid,
      title: editor.title
    }, function(data){
      if (data.status) {
        editorVue.issaved = true
        if (isnew) {
          window.location.href='/code/' + data.id 
        }
      };
    })
  }


  // 获取CDN库
  var libTimer;
  editor.getLibs = function(){
    clearTimeout(libTimer)
    libTimer = setTimeout(function(){
      editor.openBar()
      var url = 'https://api.cdnjs.com/libraries?search=' + editor.libkey + '&fields=assets'
      $.get(url, {}, function(data){
        editor.libs = data.results.slice(0, 10);
      })
    }, 500)
  }

  editor.showSub = function(event){
    $(event.target).find('ul:first').slideToggle()
    event.stopPropagation()
  }

  editor.insertAsset = function(lib, version, file){
    // cdnjs.cloudflare.com/ajax/libs/
    var link =   '/cdnjs/' + lib.name + '/' + version + '/' + file;

    var srclink = '<script src="' + link + '"></script>';
    if (/.+\.css$/.test(file)) {
      srclink = '<link rel="stylesheet" media="all" href="' + link + '" />'
    };
    
    htmlCodeMirror.setValue(htmlCodeMirror.getValue().replace(/(\s+)(<\/head>)/,'$1  ' + srclink + '$1$2'));
  }



  return editor
}

function initCodeMirror(){
  htmlCodeMirror =  AddCodeMirror('#code-html', 'text/html') 
  jsCodeMirror = AddCodeMirror('#code-js', 'javascript')
  cssCodeMirror =  AddCodeMirror('#code-css', 'css')

  init_code()

  
  htmlCodeMirror.on("change", function(){
    editorChangeHander()
  })
  cssCodeMirror.on("change", function(){
    editorChangeHander()
  })
  jsCodeMirror.on("change", function(){
    editorChangeHander()
  })
}

function editorChangeHander(){
  editorVue.issaved = false
  if (editorVue.isauto == 'true') {
    run_code()
  };
}



function AddCodeMirror(textareaId, mode){
  return  CodeMirror.fromTextArea($(textareaId)[0],{
    //lineNumbers: true,
    mode: mode,
    matchBrackets: true,
    lineWrapping: true,
    autoCloseTags: true
  })
}


//- 初始化编辑器代码
function init_code(){
  var _html =  "<!DOCTYPE html>\n\
<html>\n\
<head>\n\
  <meta charset='utf-8' \/> \n\
<\/head>\n\
<body>\n\
  \n\
<\/body>\n\
<\/html>"; 
  

  setTimeout(function(){
    htmlCodeMirror.setValue($('#code-html').val() || _html);
    jsCodeMirror.setValue($("#code-js").val());
    cssCodeMirror.setValue($("#code-css").val());
    editorVue.issaved = !isnew
    run_code()
  }, 1)
}

//- 运行
function run_code(){
  var shtml = htmlCodeMirror.getValue()
  var sjs = jsCodeMirror.getValue()
  var scss = cssCodeMirror.getValue()

  var previewFrame = $('#preview')[0];
  var preview =  previewFrame.contentDocument ||  previewFrame.contentWindow.document;

  var _js = "<script type='text/javascript'>\n\
  " + sjs + "\n\
  <\/script>";
  var _css = "<style>" + scss + "</style>";
  var _html = shtml.replace(/(\s+)(<\/head>)/,'$1  ' + _css + '$1$2');
  _html = _html.replace(/(\s+)(<\/body>)/,'$1  ' + _js + '$1$2');
  console.log(_html)
  preview.open();
  preview.write(_html); 
  preview.close();

}
