var _ = require('underscore');
var mc = require('./lib/mycrypto').mycrypto;

function notify(res,postData){
  var mem = mc.decrypt(postData.mem).split('-')[0];
  var data = _.omit(postData,'mem');
  _.each(global.io.sockets.connected,function(item){
    if (item.mem_id == mem) {
      item.emit('notify', { item: data});
    };
  })
  res.end();
}


exports.notify = notify;