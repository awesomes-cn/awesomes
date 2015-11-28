var mc = require('./lib/mycrypto').mycrypto;

function notify(res,postData){
  var mem = mc.decrypt(postData.mem).split('-')[0];

  global.sockets.forEach(function(item){
    if(item.mem == mem){
      var s = global.io.sockets.connected[item.socket];
      if(s){
        s.emit('notify', { amount: postData.amount});
      }
    }    
  })
  res.end();
}


exports.notify = notify;