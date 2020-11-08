Sys.timezone()
Sys.setenv(TZ = "Asia/Singapore")
Sys.time()

x <- as.POSIXlt(Sys.time(), tz = "Asia/Singapore")
x
