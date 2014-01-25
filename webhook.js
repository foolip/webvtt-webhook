var http = require('http');
var fs = require('fs');
http.createServer(function (req, res) {
  if (req.url == '/webvtt-webhook') {
    fs.writeFile(__dirname + '/jobs/' + Date.now(), '', function(err) {
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
