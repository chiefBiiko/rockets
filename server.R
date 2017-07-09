# rockets server

initServerSocket <- function(host='0.0.0.0', port=49419L) {
  stopifnot(is.character(host), length(host) == 1L, nchar(host) > 0L, 
            port %in% 1024L:65535L)
  # creating a server socket
  CON <- socketConnection(host=host,
                          port=port,
                          server=TRUE, 
                          blocking=TRUE, 
                          open='r',
                         #encoding='UTF-8',
                          timeout=(24L * 60L * 60L))
  # stdout on new connection
  cat('[new connection @ ', host, ':', port, ']\n', sep='')
  # logfile
  ROCKETS_LOG <- paste0('rockets-', 
                        as.character(as.integer(Sys.time())), 
                        '.log')
  # handling connections
  repeat {
    Sys.sleep(.5)
    data <- readLines(con=CON, 
                      n=1L, 
                      ok=TRUE, 
                      warn=TRUE, 
                     #encoding='UTF-8', 
                      skipNul=TRUE)
    if (length(data)) {
      cat(data, 
          file=ROCKETS_LOG, 
          sep='\n', 
          append=TRUE)
      cat('[received new data]\n')
    }
  }
}

initServerSocket()
