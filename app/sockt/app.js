var _ = require('underscore'),
    qs = require('querystring'),
    mc = require('./lib/mycrypto').mycrypto;



var server = require('http').createServer(function(req,res){
  req_para(req,res,function(para){
    var id = mc.decrypt(para.mem);
    var items = _.filter(sockets,function(item){
      return item.id == id
    })
    items.forEach(function(item){
      var s = io.sockets.connected[item.socket];
      if(s){
        s.emit('hello', { some: id});
      }
    })
    
  })
});


var req_para = function(req,res,callback){
  var body = ""
  req.on('data', function (chunk) {
    body += chunk;
  });
  req.on('end', function () {
    callback(qs.parse(body));
    res.end();
  })
}




var io = require('socket.io')(server);

var sockets = []

io.on('connection', function(socket){
  
  //- 标识每个客户端
  socket.on('set', function(data){
    sockets[sockets.length] = {
      socket: socket.id,
      id: data.id
    }
    socket.mem_id = data.id
  });

  socket.on('disconnect', function(){
    var del_item = _.find(sockets,function(item){
      return item.socket == socket.id
    })

    sockets = _.without(sockets,del_item)

  });
  
});
server.listen(8080);
