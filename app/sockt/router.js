function route(handle,pathname,res,postData){
  if(typeof handle[pathname] === 'function'){
    return handle[pathname](res,postData);
  }else{
    res.writeHead(404);
    res.write('404 not found');
    res.end();
  }
}

exports.route = route;