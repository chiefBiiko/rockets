# rockets client
PORT <- 36000

# Establishing a connection 2 the server-side
CON <- socketConnection(host='localhost', port=PORT, server=F, blocking=T, open='r+')
print(summary.connection(CON))

# Sending text thru the connection
writeLines('419 business', CON)

# Reading response from server
readLines(CON, 1)

# Close the connection once done
close(CON)