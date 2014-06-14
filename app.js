var app, express, io, net, socket_io, tribe;

net = require('net');

express = require('express');

socket_io = require('socket.io');

app = express().use(express["static"](__dirname + '/htdocs')).listen(8080);

io = socket_io.listen(app).set("log level", 3);

tribe = net.createConnection({
  ip: 'localhost',
  port: 6555
}, function() {
  tribe.setEncoding('utf8');
  tribe.write(JSON.stringify({
    category: 'tracker',
    request: 'set',
    values: {
      push: true
    }
  }));
  return setInterval((function() {
    return tribe.write(JSON.stringify({
      "category": "heartbeat"
    }));
  }), 2000);
});

tribe.on('error', function(err) {
  return console.error('TheEyeTribe error', err);
});

tribe.on('close', function() {
  return console.log('TheEyeTribe close');
});

tribe.on('data', function(data) {
  var err, o, _ref;
  try {
    o = JSON.parse(data);
    if ((o != null ? (_ref = o.values) != null ? _ref.frame : void 0 : void 0) != null) {
      console.log(o.values.frame.avg.x + '\t\t' + o.values.frame.avg.y);
      return io.sockets.emit('frame', data);
    }
  } catch (_error) {
    err = _error;
    return console.error('Malformed JSON', err);
  }
});