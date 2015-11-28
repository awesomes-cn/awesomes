var server = require('./server'),
    router = require('./router'),
    requestHandlers = require('./requestHandlers');

var handle = {
  "/notify" : requestHandlers.notify
}

server.start(router.route, handle)    