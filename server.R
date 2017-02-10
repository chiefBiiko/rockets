# rockets server
PORT <- 36000

# Creating a server socket
CON <- socketConnection(host='localhost', port=PORT, server=T, blocking=T, open='r+')
print(summary.connection(CON))

# Handling connections
while (try(isOpen(CON), T)) {
  data <- readLines(CON, 1)
  writeLines(gsub('s|ß|z', '$', data, ignore.case=T), CON)  # send back response
}

close(CON)