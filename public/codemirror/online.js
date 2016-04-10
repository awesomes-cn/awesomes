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
      isauto: localStorage.autoruncode || false

    },
    computed: {
      isauthor: function () {
        return Rails.mem.id == codeAuthor
      }
    }
  })

  
  // 初始化
  var editareaw = $(id).find('.code-editor').width()
  console.log($(id).width())
  var basew = parseInt(editareaw / 3)
  var baseh = parseInt(($(id).height() - 40) * 0.4)
  editor.p1.w = basew + 'px'
  editor.p1.h = baseh + 'px'
  editor.p2.w = basew + 'px'
  editor.p3.w = (editareaw - basew * 2 - 5 * 2) + 'px'
  editor.p4.h = (($(id).height() - 40) - baseh - 5) + 'px'


  
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
  

  // 切换左侧栏 折叠 / 展开
  editor.switchLeft = function(event){
    if(editor.left.state == 'ing') return 
    
    var param = {
      // 折叠
      fold: {
        distance: editor.left.w - 20,
        icon: 'fa-angle-right',
        state: 'open'

      },
      // 展开
      open: {
        distance: 20 - editor.left.w,
        icon: 'fa-angle-left',
        state: 'fold'

      },
    }[editor.left.state] 


    var distance = param.distance
    if (editor.left.state == 'open') {
      editor.p3.w = parseInt(editor.p3.w) + distance + 'px' 
    }else{
      $(id).find('.inner-out').fadeOut()
    }
    editor.left.state = 'ing'
    
    $(id).find('.left-bar').animate({width: '-=' + distance})
    $(id).animate({paddingLeft: '-=' + distance}, function(){ 
      $(event.target).find('i').attr('class', 'fa ' + param.icon)
      editor.left.state = param.state
      if (editor.left.state == 'open') {
        editor.p3.w = parseInt(editor.p3.w) + distance + 'px'
      }else{
        $(id).find('.inner-out').fadeIn()
      }
    })
   
  }

  // 切换自动运行
  editor.switchAuto = function(){
    editor.isauto = !editor.isauto;
    localStorage.autoruncode = editor.isauto
  }

  //fork
  editor.fork = function(){
    if(open_login()){
      $('#fork-wraper').show().animate({top: 0})
    }
    
  }
 

  return editor
}

function initCodeMirror(){
  htmlCodeMirror =  AddCodeMirror('#code-html', 'text/html') 
  jsCodeMirror = AddCodeMirror('#code-js', 'javascript')
  cssCodeMirror =  AddCodeMirror('#code-css', 'css')

  init_code()

  
  htmlCodeMirror.on("change", function(){
    if (editorVue.isauto) {
      run_code()
    };
  })
  cssCodeMirror.on("change", function(){
    if (editorVue.isauto) {
      run_code()
    };
  })
  jsCodeMirror.on("change", function(){
    if (editorVue.isauto) {
      run_code()
    };
  })
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
    htmlCodeMirror.setValue(_html);
    jsCodeMirror.setValue('');
    cssCodeMirror.setValue('');
  }, 1)
}

//- 运行
function run_code(){
  var shtml = htmlCodeMirror.getValue()
  var sjs = jsCodeMirror.getValue()
  var scss = cssCodeMirror.getValue()

  var previewFrame = $('#preview')[0];
  var preview =  previewFrame.contentDocument ||  previewFrame.contentWindow.document;

  var _js = "<script type='text/javascript'>" + sjs + "<\/script>";
  var _css = "<style>" + scss + "</style>";
  var _html = shtml.replace(/(\s+)(<\/head>)/,'$1  ' + _js + _css+'$1$2');
  preview.open();
  preview.write(_html); 
  preview.close();

}
