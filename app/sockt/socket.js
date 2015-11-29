var _ = require('underscore'),
    mc = require('./lib/mycrypto').mycrypto;

function start(server){
  global.io = require('socket.io')(server);

  global.io.on('connection', function(socket){
    
    //- 标识每个客户端
    socket.on('auth', function(data){
      socket.mem_id = mc.decrypt(data.mem).split('-')[0];
    });

    socket.on('disconnect', function(){
      var del_item = _.find(global.sockets,function(item){
        return item.socket == socket.id
      })

      global.sockets = _.without(global.sockets,del_item)

    });
    
  });
  server.listen(8080);
}

exports.start = start;