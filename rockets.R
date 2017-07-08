# rockets

#' Open a client connection to a socket server
#' 
#' @param host character. Host name for the port.
#' @param port integer. The TCP port number.
#' @param open character. Opening mode for connection, can be any of:
#' \code{c('a', 'a+', 'r')}; duplex by default: \code{'a+'}.
#' @return sockconn. Connection object.
#' 
#' @export
openRocket <- function(host, port, open='a') {
  stopifnot(grepl('[[:alnum:][:punct:]]+', host, perl=TRUE),
            is.numeric(port) && port %in% 0L:65535L,
            open %in% c('a', 'a+', 'r'))
  rocket <- socketConnection(host=host, 
                             port=port, 
                             server=FALSE, 
                             blocking=FALSE, 
                             open=open,
                             encoding='UTF-8',
                             timeout=30L)
  return(rocket)
}

#' Write a bitjson array to a socket
#' 
#' @param x Any R object or a bitjson array.
#' @param socket sockconn. An open connection object.
#' @return integer. Invisible \code{0} only if writing to the socket succeeded.
#' 
#' @export
pumpOutBitJSON <- function(x, socket) {
  stopifnot(tryCatch(isOpen(socket), error=function(err) FALSE))
  if (!bitjson::looksLikeBitJSON(x)) x <- bitjson::toBitJSON(x)
  writeChar(x, socket, nchars=nchar(x, type='chars'), eos='\n', useBytes=FALSE)
  return(invisible(0L))
}

#' Read in new-line delimited bitjson from a log file
#' 
#' @param ndbitjson Character vector of length \code{1}, the filename.
#' @return R objects. 
#'
#' @export
fromNdBitJSON <- function(ndbitjson, diff.only=TRUE) {
  if (file.exists(ndbitjson) || 
      grepl('^(?:https?)|(?:ftps?)\\:\\/\\/$', ndbitjson, perl=TRUE)) {
    bitjson.lines <- readLines(ndbitjson)
    if (!length(bitjson.lines)) return(NULL) 
  } else if (is.character(ndbitjson) && length(ndbitjson)) {
    bitjson.lines <- ndbitjson
  } else { stop('invalid input') }
  if (!all(sapply(list(bitjson.lines), bitjson::looksLikeBitJSON))) {
    warning('input is not strictly new-line delimited bitjson\n',
            'returning unparsed lines...better to parse manually')
    return(bitjson.lines)
  }
  #
  # TODO: diff check against an env var holding prev reads
  #
  if (diff.only) {
    
  }
  return(lapply(as.list(bitjson.lines), bitjson::fromBitJSON))
}

#' Read in an entire bitjson array from a socket
#' 
#' @param socket sockconn. An open connection object.
#' @param unmarshal logical. Should the bitjson array be unmarshaled?
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