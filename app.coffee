net       = require('net')
express   = require('express')
socket_io = require('socket.io')

app = express()
  .use(express.static(__dirname + '/htdocs'))
  .listen(8080)

io = socket_io
  .listen(app)
  .set("log level", 3)

tribe = net.createConnection {ip: 'localhost', port: 6555}, ->
  tribe.setEncoding('utf8')
  tribe.write JSON.stringify
    category: 'tracker'
    request: 'set'
    values: {push: true}
  setInterval (->
    tribe.write JSON.stringify "category": "heartbeat"
  ), 2000

tribe.on 'error', (err)-> console.error 'TheEyeTribe error', err
tribe.on 'close',      -> console.log   'TheEyeTribe close'
tribe.on 'data', (data)->
  try
    o = JSON.parse(data)
    if o?.values?.frame?
      console.log(o.values.frame.avg.x+'\t\t'+o.values.frame.avg.y)
      io.sockets.emit('frame', data)
  catch err
    console.error 'Malformed JSON', err
