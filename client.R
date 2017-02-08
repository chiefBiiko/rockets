# rockets client
PORT <- 36000
DONE <- F
message('Run rocket("ur payload") 2 communicate with the server,
        rocket("EXIT") 2 shut down client and server socket.')
# Establish a connection 2 the server-side
clientInit <- function(port=PORT) {
  CON <<- socketConnection(host='localhost', port=port, server=F, blocking=T, open='r+')
  print(paste0('Connected on port ', port))
}
# Shut client socket
clientKill <- function() {
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
# Starting the client
clientInit()
# Printing payload
while (!DONE) {  # isIncomplete(CON) evaluates 2 F before response been sent 
  data <- readLines(CON, 1)
  print(data)
  if (data == 'EXIT') clientKill()
}