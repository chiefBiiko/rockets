# rockets server
PORT <- 36000
DONE <- F
message('Run serverInit() to establish a socket connection, serverKill() to shut it down.')
# Provide a socket server
serverInit <- function(port=PORT) {
  CON <<- socketConnection(host='localhost', port=port, server=T, blocking=T, open='r+')
  print(paste0('Listening on port ', port))
}
# Shut a server socket
serverKill <- function() {
  DONE <<- T
  close(CON)
  rm(CON, envir=globalenv())
}
# Send text thru the socket
rocket <- function(text) {
  stopifnot(typeof(text) == 'character')
  if (!exists('CON')) clientInit()
  writeLines(text, CON)
  if (text == 'EXIT') clientKill() 
}
# Starting the server
serverInit()
# Printing payload
while (!DONE) {  # isIncomplete(CON) evaluates 2 F before response been sent 
  data <- readLines(CON, 1)
  print(data)
  if (data == 'EXIT') serverKill()
}