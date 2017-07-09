# launch

launch <- function(host='127.0.0.1', port=10419L) {  # username, peer, 
  # hashToPort username...
  # create a socket connection to peer
  # start server child
  PID <- sys::exec_background(cmd=sprintf('Rscript.exe %s', 'server.R'),
                              args=c(host, port))
  # exit with server child PID & outbound rocket
  return(PID)
}