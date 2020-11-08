# FE8828 Blockchain class
# Free to use
# No

# change to where this project file are
setwd("~/fe8828_r_blockchain")

list.of.packages <- c("plumber","jsonlite")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

require(plumber)
require(jsonlite)

custom_json <- function(){
  function(val, req, res, errorHandler){
    tryCatch({
      json <- jsonlite::toJSON(val, auto_unbox=TRUE)
      
      res$setHeader("Content-Type", "application/json")
      res$body <- json
      
      return(res$toResponse())
    }, error = function(e){
      errorHandler(req, res, e)
    })
  }
}

addSerializer("custom_json",custom_json)

# Make sure you put the path to your blockchain-node-server.R script
r <- plumb("blockchain-node-server.R")
r$run(host = "0.0.0.0", port=8000)

# http://127.0.0.1:8000/__swagger__/
