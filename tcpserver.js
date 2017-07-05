/* tcpserver */

const net = require('net')
const fs = require('fs')
const pump = require('pump')

net.createServer(socket => {
  console.log('[new connection]')
  socket.setEncoding('utf8')
  pump(fs.createReadStream('nile.json'), socket, err => {
    if (err) console.error(err)
  })
  socket.on('data', data => {
    console.log(data.replace(/\s+$/, ''))
  })
  socket.on('close', had_error => {
    console.log('[closed a connection]')
  })
}).listen(10419, 'localhost', () => console.log('l.o.p. 10419'))