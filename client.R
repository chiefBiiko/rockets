# rockets client
PORT <- 36000
message('Run rocket("ur payload") 2 communicate with the server,
        rocket("EXIT") 2 shut down client and server socket.')
# Establish a connection 2 the server-side
clientInit <- function(port=PORT) {
  CON <<- socketConnection(host='localhost', port=port, server=F, blocking=T, open='r+')
}
# Shut client socket
clientKill <- function() {
  close(CON)
  rm(CON, envir=globalenv())
}
# Send text thru the socket and print response
rocket <- function(text) {
  stopifnot(typeof(text) == 'character')
  if (!exists('CON')) clientInit() 
  writeLines(text, CON)
  server.resp <- readLines(CON, 1)
  print(server.resp)
  if (text == 'EXIT') clientKill() 
}