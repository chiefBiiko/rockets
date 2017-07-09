# launchpad

launch <- function(username, peer, domain='0.0.0.0') {
  # hashToPort username 
  # start server.R as child with sys::exec_background
  # create a socket connection to peer
  # return PID of child process and rocket object
  PID <- sys::exec_background(cmd=sprintf('Rscript.exe %s', 'server.R'))
  PID
}