# launch

launch <- function(host='127.0.0.1', port=10419L) {  # username, peer, 
  # hashToPort username...
  # create a socket connection to peer
  # start server child
  RSCRIPT <- normalizePath(file.path(R.home(), 'bin', 'Rscript.exe'))
  RSERVER <- 'server.R'  # file.path(.libPaths()[1L], 'rockets', 'server.R')
  PID <- sys::exec_background(cmd=RSCRIPT,
                              args=c(RSERVER, host, port))
  # exit with server child PID & outbound rocket
  return(PID)
}