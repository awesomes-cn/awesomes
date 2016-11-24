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
      p3: {h: 0, oh: 0},
      p4: {h: 0, oh: 0},
      ox: 0,
      oy: 0,
      left: {w: 200, ow: 200, state: 'fold'},
      right: {w: 200, ow: 200, state: 'fold'},
      isauto: localStorage.autoruncode || 'false',
      login: Rails.login,
      issaved: true,
      libs: [],
      libkey: '',
      toolboxState: 'closed',
      libLoadState: 'ready'

    }
  })

  
  // 初始化
  var editareaw = $(id).find('.code-css-editor').width()

  var editareah = $(id).find('.code-css-editor').height()
  
  var basew = parseInt(editareaw / 2)
  var baseh = parseInt(editareah - 40)
  editor.p1.w = basew + 'px'
  editor.p1.h = baseh + 'px'
  editor.p2.w = (editareaw - basew  - 5 * 2) + 'px'
  editor.p2.h = baseh + 'px'
  editor.p3.h = baseh / 3 + 'px'
  editor.p4.h = (baseh -  parseInt(editor.p3.h)) + 'px'


  
  // 横向移动
  editor.moveX = function(e, pleft, pright){
    $('.window-cover').show()
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
    var ptop = editor.p3
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
  

  editor.openBar = function(){
   editor.toolboxState = 'ing'
    $('#toolbox').animate({right: 1}, function(){
      editor.toolboxState = 'open'
    })
  }
  editor.closeBar = function(){
    editor.toolboxState = 'ing'
    $('#toolbox').animate({right: -300}, function(){
      editor.toolboxState = 'closed'
    })
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
      //js: jsCodeMirror.getValue(),
      html: htmlCodeMirror.getValue(),
      id: itemid,
      rid: rid,
      title: editor.title
    }, function(data){
      if (data.status) {
        editorVue.issaved = true
        //if (isnew) {
         // window.location.href='/code/' + data.id 
       // }
      };
    })
  }

  return editor
}

function initCodeMirror(){
  htmlCodeMirror =  AddCodeMirror('#code-html', 'text/html') 
  //jsCodeMirror = AddCodeMirror('#code-js', 'javascript')
  cssCodeMirror =  AddCodeMirror('#code-css', 'css')

  init_code()

  
  htmlCodeMirror.on("change", function(){
    editorChangeHander()
  })
  cssCodeMirror.on("change", function(){
    editorChangeHander()
  })
  /*jsCodeMirror.on("change", function(){
    editorChangeHander()
  })*/
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
  var _html =  "<div>\n\
  \n\
  \n\
<\/div>"; 

  var _css = "body{\n\
  margin: 0;  \n\
  padding: 0;  \n\
}"
  

  setTimeout(function(){
    htmlCodeMirror.setValue($('#code-html').val() || _html);
    //jsCodeMirror.setValue($("#code-js").val());
    cssCodeMirror.setValue($("#code-css").val() || _css);
    //editorVue.issaved = !isnew
    run_code()
  }, 1)
}

//- 运行
function run_code(){
  var shtml = htmlCodeMirror.getValue()
  var _base =  "<!DOCTYPE html>\n\
<html>\n\
<head>\n\
  <meta charset='utf-8' \/> \n\
<\/head>\n\
<body>\n\
  \n\
<\/body>\n\
<\/html>";

  shtml = _base.replace(/(\s+)(<\/body>)/,'$1  ' + shtml + '$1$2');

  //var sjs = jsCodeMirror.getValue()
  var scss = cssCodeMirror.getValue()

  var previewFrame = $('#preview')[0];
  var preview =  previewFrame.contentDocument ||  previewFrame.contentWindow.document;

  var _css = "<style>" + scss + "</style>";
  var _html = shtml.replace(/(\s+)(<\/head>)/,'$1  ' + _css + '$1$2');
  

  //_html = _html.replace(/(\s+)(<\/body>)/,'$1  ' + _js + '$1$2');
  //_html = _html.replace(/src="(\s+)?\/jsdelivr\//g,'$1  ' + _js + '$1$2');

  console.log(_html)
  preview.open();
  preview.write(_html); 
  preview.close();

}
