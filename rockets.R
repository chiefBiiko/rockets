# rockets

#' Open a client connection to a socket server
#' 
#' @param host Character. Host name for the port.
#' @param port Integer. The TCP port number.
#' @param open Character. Opening mode for connection, can be any of:
#' \code{c('a', 'a+', 'r')}; duplex by default: \code{'a+'}.
#' @return Sockconn. Connection object.
#' 
#' @export
openRocket <- function(host, port, open='a') {
  stopifnot(grepl('[[:alnum:][:punct:]]+', host, perl=TRUE),
            port %in% 1024L:65535L,
            open %in% c('a', 'a+', 'r'))
  rocket <- socketConnection(host=host, 
                             port=port, 
                             server=FALSE, 
                             blocking=FALSE, 
                             open=open,
                            #encoding='UTF-8',
                             timeout=30L)
  return(rocket)
}

#' Write a bitjson array to a socket
#' 
#' @param x Any R object or a bitjson array.
#' @param socket Sockconn. An open connection object.
#' @return Integer. Invisible \code{0} only if writing to the socket succeeded.
#' 
#' @export
pumpOutBitJSON <- function(x, socket) {
  stopifnot(tryCatch(isOpen(socket), error=function(err) FALSE))
  if (!bitjson::looksLikeBitJSON(x)) x <- bitjson::toBitJSON(x)
  #x <- iconv(x, from='', to='UTF-8')
  writeChar(object=x,
            con=socket,
            nchars=nchar(x, type='chars'),
            eos='\n',
            useBytes=TRUE)
  return(invisible(0L))
}

#' Parse new-line delimited bitjson
#' 
#' @param ndbitjson Character vector of length \code{1}; filename, url, or
#' in-memory \code{JSON} string.
#' @param diff.only Logical. Should only diffs within a \code{R} session 
#' be returned? Useful for repeatedly parsing bitjson log files into memory.
#' @return List. 
#'
#' @export
fromNdBitJSON <- function(ndbitjson, diff.only=FALSE) {
  stopifnot(is.logical(diff.only))
  if (file.exists(ndbitjson) || 
      grepl('^(?:https?)|(?:ftps?)\\:\\/\\/.+', ndbitjson, perl=TRUE)) {
    bitjson.lines <- readLines(ndbitjson)  #, encoding='UTF-8'
    if (!length(bitjson.lines)) return(NULL) 
  } else if (is.character(ndbitjson) && length(ndbitjson) == 1L) {
    bitjson.lines <- strsplit(ndbitjson, '\n', TRUE)[[1L]]
  } else { stop('invalid input') }
  if (!all(sapply(as.list(bitjson.lines), bitjson::looksLikeBitJSON))) {
    warning('input is not strictly new-line delimited bitjson\n',
            'returning unparsed lines...better to parse manually')
    return(bitjson.lines)
  }
  if (diff.only) {
    old.lines <- strsplit(Sys.getenv('ROCKETS_NDBITJSON'), '\n', TRUE)[[1L]]
    Sys.setenv(ROCKETS_NDBITJSON=paste0(bitjson.lines, collapse='\n'))
    bitjson.lines <- bitjson.lines[!bitjson.lines %in% old.lines]
  }
  return(lapply(as.list(bitjson.lines), bitjson::fromBitJSON))
}

#' Read in an entire bitjson array from a socket
#' 
#' @param socket Sockconn. An open connection object.
#' @param unmarshal Logical. Should the bitjson array be unmarshaled?
#' @return \code{NULL} if buffer is empty; otherwise if \code{!unmarshal}
#' bitjson array else if \code{unmarshal} R object.
#'
#' 
pumpInBitJSON <- function(socket, unmarshal=TRUE) {
  stopifnot(tryCatch(isOpen(socket), error=function(err) FALSE),
            is.logical(unmarshal))
  payload <- vector('character')
  Sys.sleep(.01)  # allow buffer 2 fill up
  repeat {
    payload <- append(payload, char <- readChar(socket, 1L, useBytes=FALSE))
    if (length(char) == 0L) break
  }
  if (length(payload) == 0L) {
    return(NULL)
  } else if (unmarshal) {
    return(bitjson::fromBitJSON(paste0(payload, collapse='')))
  } else if (!unmarshal) {
    return(structure(paste0(payload, collapse=''), class='json'))
  }
}