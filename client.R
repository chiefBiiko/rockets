# rockets client
PORT <- 36000
message('Run rocket("EXIT", CON) 2 shut down client and server socket.')

# Establishing a connection 2 the server-side
CON <- socketConnection(host='localhost', port=PORT, server=F, blocking=T, open='r+')
print(paste0('Connected on port ', PORT))
print(summary.connection(CON))

# Sending text thru the connection n printing response
rocket <- function(text) {
  stopifnot(typeof(text) == 'character', exists('CON'))
  writeLines(text, CON)
  print(readLines(CON, 1))
  if (text == 'EXIT') close(CON) 
}