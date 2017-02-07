# rockets server
PORT <- 36000
DONE <- F
message('Run serverInit() to establish a socket connection, serverKill() to shut it down.')
# Provide a socket server
serverInit <- function(port=PORT) {
  CON <<- socketConnection(host='localhost', port=port, server=T, blocking=T, open='r+')
  #on.exit(close(CON))
  print(paste0('Listening on port ', PORT))
  while (!DONE) {  # isIncomplete(CON) evaluates 2 F before response been sent 
    data <- readLines(CON, 1)
    response <- toupper(data)
    writeLines(response, CON)
    if (data == 'EXIT') serverKill()
  }
}
# Shut a server socket
serverKill <- function() {
  DONE <<- T
  close(CON)
  rm(CON, envir=globalenv())
}
# Starting the server
serverInit()