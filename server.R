# rockets server
PORT <- 36000

# Creating a server socket
CON <- socketConnection(host='localhost', port=PORT, server=T, blocking=T, open='r+')
print(paste0('Listening on port ', PORT))
print(summary.connection(CON))

# Handling connections
while (isOpen(CON)) {
  data <- readLines(CON, 1)
  writeLines(toupper(data), CON)  # some pure func 2 generate response
  print(data)
  if (length(data) > 0 && data == 'EXIT') close(CON)
}