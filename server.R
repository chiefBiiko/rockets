# rockets server

# creating a server socket
CON <- socketConnection(host='0.0.0.0',
                        port=49419L,
                        server=T, 
                        blocking=T, 
                        open='r')

cat('[new connection on 0.0.0.0:49419]')

# handling connections
repeat {
  data <- readLines(CON, 1L, skipNul=TRUE)
  if (length(data) > 0L) cat(data,
                             file='R_server.log', 
                             sep='\n', 
                             append=TRUE)
}
