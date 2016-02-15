var ip = require('ip');
var redis = require('redis');
var restify = require('restify');

var db = redis.createClient({ host: 'redis' });
var server = restify.createServer({
  name: 'demo'
});

var message = process.env.MESSAGE || 'Hello, world';

server.get('/', function (req, res, next) {
  db.incr('hits', function (err, result) {
    if (err) {
      return next(err);
    }
    var s = [
      message + ' ' + ip.address() + '!',
      result + ' hits.'
    ].join(' ');
    res.send(200, s);
    return next();
  });
});

server.listen(9000);
