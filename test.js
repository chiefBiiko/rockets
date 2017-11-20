const tape = require('tape')
const prettify = require('./index')

tape('extendo', t => {
  const mem = process.memoryUsage()
  const pretty = prettify(mem)
  const expected = [
    'rss',
    'heapTotal',
    'heapUsed',
    'external',
    'heapUsedPercent',
    'heapUsedMB'
  ]

  t.same(Object.keys(pretty), expected,
         'mem obj extended by ".heapUsedPercent", and ".heapUsedMB"')
  t.end()

})

tape('types', t => {
  const mem = process.memoryUsage()
  const pretty = prettify(mem)

  t.is(Object.getPrototypeOf(pretty.heapUsedPercent), Number.prototype,
       'pretty.heapUsedPercent is a number')

  t.is(Object.getPrototypeOf(pretty.heapUsedMB), Number.prototype,
       'pretty.heapUsedMB is a number')
  t.end()
  
})
