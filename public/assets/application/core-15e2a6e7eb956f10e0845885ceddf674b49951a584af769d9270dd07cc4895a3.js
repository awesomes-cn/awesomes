window.Core = {
  // 提示
  alert: function(typ, msg, position) {
    position = position || 'top-center' 
    var delay =  3000
    var top = 50
    var box = $('<div class="alert alert-pop alert-' + typ + ' alert-tip alert-' + position + '" role="alert" >' + msg + '</div>')
    $('body').append(box)
    box.animate({top: top}, ()=> {
      setTimeout(()=> {
        box.remove()
      }, delay)
    })
  }
}
;
