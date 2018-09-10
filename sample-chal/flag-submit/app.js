const http = require('http');
const fs = require('fs');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  let flag = '';
  req.on('data', (chunk) => {
    flag += chunk;
  })
  req.on('end', () => {
    fs.writeFileSync('/flag', flag);
  })
  res.end('ok')
});
server.listen(8080);
