var http = require('http');
var fs = require('fs');
http.createServer(function (req, res) {
  if (req.url == '/webvtt-webhook') {
    var job = __dirname + '/jobs/' + Date.now();
    var msg = 'job queued by ' + req.socket.remoteAddress +
              ' at ' + new Date().toISOString() + '\n';
    fs.writeFile(job, msg, function(err) {
      if (err) {
        console.log(err);
        res.statusCode = 500;
      }
      res.end(http.STATUS_CODES[res.statusCode]);
    });
  } else {
    res.statusCode = 404;
    res.end(http.STATUS_CODES[res.statusCode]);
  }
}).listen(8777);
