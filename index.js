const ops = require('pojo-ops')

module.exports = function prettify (mem) {
  return ops.extend(mem, {
    heapUsedPercent: Math.round((mem.heapUsed / mem.heapTotal) * 100) / 100,
    heapUsedMB: Math.round((mem.heapUsed / 1024 / 1024) * 100) / 100
  })
}
