# pretty-heap-used

[![build status](http://img.shields.io/travis/chiefbiiko/pretty-heap-used.svg?style=flat)](http://travis-ci.org/chiefbiiko/pretty-heap-used) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/chiefbiiko/pretty-heap-used?branch=master&svg=true)](https://ci.appveyor.com/project/chiefbiiko/pretty-heap-used)

***

Basically `process.memoryUsage()` + `.heapUsedPercent` + `.heapUsedMB`.

***

## Get it

```js
npm install --save pretty-heap-used
```

***

## Usage

Just pass the return object of `process.memoryUsage` to the prettifier and gain two extra pretty properties.

```js
const prettyHeap = require('pretty-heap-used')

prettyHeap(process.memoryUsage())
// -> { rss: 123, heapTotal: 123, heapUsed: 123, external: 123, heapUsedPercent: 0.123, heapUsedMB: 123 }
```

***

## License

[MIT](./license.md)