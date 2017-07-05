# rockets server

# Creating a server socket
CON <- socketConnection(host='localhost', port=36000, server=T, blocking=T, open='r+')
print(summary.connection(CON))

# Handling connections
while (isTRUE(try(isOpen(CON), T))) {
  data <- readLines(CON, 1)
  if (length(data) > 0) writeLines(gsub('s|ß|z', '$', data, ignore.case=T), CON)  # send back response
}

close(CON)