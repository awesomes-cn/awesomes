var qs = require('querystring'),
    url = require('url'),
    socket = require('./socket');


function start(route,handle){
  function onRequest(req,res){
    var postData = "",
        pathname = url.parse(req.url).pathname;

    req.setEncoding('utf8');
    req.addListener("data",function(postDataChunk){
      postData += postDataChunk;
    })

    req.addListener("end",function(){
      route(handle,pathname,res,qs.parse(postData));
    })
    
  }
  
  socket.start(require('http').createServer(onRequest));

}


exports.start = start;







