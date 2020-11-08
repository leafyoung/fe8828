library(jsonlite)
library(httr)

# to register a node
req <- POST("http://127.0.0.1:8000/nodes/register", 
            body = '{"nodes": "http://127.0.0.1:8000"}')
cat(jsonlite::fromJSON(content(req, "text")))

# create a new transaction
req <- POST("http://127.0.0.1:8000/transactions/new", 
            body = '{"sender": "d4ee26eee15148ee92c6cd394edd964", 
            "recipient": "23448ee92cd4ee26eee6cd394edd964", "amount": 15}')
object <- jsonlite::fromJSON(content(req, "text"));object$message

# create a new transaction
req <- POST("http://127.0.0.1:8000/transactions/new", 
            body = '{"sender": "6eee15148ee92c6cd394edd974d4ee2", 
            "recipient": "15148ee92cd4ee26eee6cd394edd964", "amount": 225}')
object <- jsonlite::fromJSON(content(req, "text"));object$message

# start mining
req <- GET("http://127.0.0.1:8000/mine")
object <- jsonlite::fromJSON(content(req, "text"));object$message

# create a new transaction
req <- POST("http://127.0.0.1:8000/transactions/new", 
            body = '{"sender": "334e15148ee92c6cd394edd974d4ee2", 
            "recipient": "8ee98ee92cd4ee26eee6cd3334e1514", "amount": 887}')
object <- jsonlite::fromJSON(content(req, "text"));object$message

# mine again
req <- GET("http://127.0.0.1:8000/mine")
object <- jsonlite::fromJSON(content(req, "text"));object$message

# retrieve the chain
req <- GET("http://127.0.0.1:8000/chain")
chain <- jsonlite::fromJSON(content(req, "text"))

# check the amount of the first transaction in the first block of the chain
chain$chain$block.1$transactions$transaction$amount

chain$chain$block.2$transactions$transaction$amount
