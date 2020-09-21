list.of.packages <- c("uuid")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

require(uuid)
# make sure you put the path of your blockchain.R file

source("blockchain.R")

# Generate a globally unique address for this node
node_identifier = gsub('-','',UUIDgenerate())
# Instantiate the Blockchain
blockchain = Blockchain()
# genesis block
blockchain$nextBlock(previousHash=1, nonce=100)

#* @get /chain/show
#* @html
function(req)
{
  render.html <- ""
  
  render.html <- paste0(render.html, '<div>')
  render.html <- paste0(render.html, '<h1>Current nodes:</h1>')
  if (length(blockchain$nodes) > 0) {
    for (i in 1:length(blockchain$nodes))
    {
      render.html <- paste0(render.html, '<b>Node:</b>' , i ,'<br>')
      render.html <- paste0(render.html, 'name:', blockchain$nodes[i][1])
      render.html <- paste0(render.html, '<br>')
    }
  }
  render.html <- paste0(render.html, '<br>')
  render.html <- paste0(render.html, '</div>')
  
  render.html <- paste0(render.html, '<div>')
  render.html <- paste0(render.html, '<h1>Current transactions:</h1>')
  if (length(blockchain$currentTransactions) > 0) {
    for (i in 1:length(blockchain$currentTransactions))
    {
      render.html <- paste0(render.html, '<b>Transaction:</b>', i ,'<br>')
      render.html <- paste0(render.html, 'sender:', blockchain$currentTransactions[i]$transaction$sender)
      render.html <- paste0(render.html, '<br>')
      render.html <- paste0(render.html, 'recipient:', blockchain$currentTransactions[i]$transaction$recipient)
      render.html <- paste0(render.html, '<br>')
      render.html <- paste0(render.html, 'amount:', blockchain$currentTransactions[i]$transaction$amount)
      render.html <- paste0(render.html, '<br>')
    }
  }
  render.html <- paste0(render.html, '<br>')
  render.html <- paste0(render.html, '</div>')
  
  render.html <- paste0(render.html, '<div>')
  render.html <- paste0(render.html, '<h1>Current block:</h1>')
  for (i in 1:blockchain$lastBlock()$block$index)
  {
    render.html <- paste0(render.html, '<br>')
    render.html <- paste0(render.html, '<b>Block nr:</b>', blockchain$chain[i]$block$index)
    render.html <- paste0(render.html, '<br>')
    render.html <- paste0(render.html, '<b>Transactions:</b>')
    render.html <- paste0(render.html, '<br>')
    if (length(blockchain$chain[i]$block$transactions) > 0 ) {
      for (j in 1:length(blockchain$chain[i]$block$transactions)) {
        render.html <- paste0(render.html, blockchain$chain[i]$block$transactions[j])
        render.html <- paste0(render.html, '<br>')
      }
    }
    render.html <- paste0(render.html, '<b>Nonce:</b>')
    render.html <- paste0(render.html, '<br>')
    render.html <- paste0(render.html,blockchain$chain[i]$block$nonce)
    render.html <- paste0(render.html, '<br>')
    if (i > 1) {
      render.html <- paste0(render.html, "<b>Proof guess:</b>")
      render.html <- paste0(render.html, '<br>')
      render.html <- paste0(render.html, blockchain$guessProof(blockchain$chain[i-1]$block$nonce, blockchain$chain[i]$block$nonce))
      render.html <- paste0(render.html, '<br>')
    }
    render.html <- paste0(render.html, '<hr>')
  }
  render.html <- paste0(render.html, '<br>')
  render.html <- paste0(render.html, '</div>')
  
  render.html
}

#* @serializer custom_json
#* @get /chain
function(req)
{
  list('length'= length(blockchain$chain),
       'chain' = blockchain$chain)
}

#* @serializer custom_json
#* @get /transactions/new
#* @post /transactions/new
function(req, sender, recipient, amount)
{
  # eg req_json <- '{"sender": "my address", "recipient": "someone else address", "amount": 5}'
  # values <- jsonlite::fromJSON(req_json)
  if (req$REQUEST_METHOD == "GET") {
    values <- list(sender = sender,
                   recipient = recipient,
                   amount = amount)
  } else if (req$REQUEST_METHOD == "POST") {
    values <- jsonlite::fromJSON(req$postBody)    
  }

  # Check that the required fields are in the POST'ed data
  required = c('sender','recipient', 'amount')
  if (!all(required %in% names(values))) {
    return ('Missing Values - sender, recipient and amount are required')
  }
  index <- blockchain$addTransaction(values$sender, values$recipient, values$amount)
  
  list('message' = paste('Transaction will be added to Block', index))
}

#* @serializer custom_json
#* @get /mine
function(req)
{
  # We run the proof of work algorithm to get the next nonce
  lastBlock <- blockchain$lastBlock()
  lastNonce <- lastBlock$block$nonce
  
  nonce <- blockchain$proofOfWork(lastNonce)
  
  # We must receive a reward for finding the Nonce.
  # The sender is "0" to signify that this node has mined a new coin.
  blockchain$addTransaction(sender="0", recipient = node_identifier, amount=1)
  
  # Forge the new block by adding it to the chain
  previousHash <- blockchain$hashBlock(lastBlock)
  block <- blockchain$nextBlock(nonce, previousHash)
  list('message'='New block forged',
       'index'= block$block$index,
       'transactions'= block$block$transactions,
       'nonce'=block$block$nonce,
       'previousHash'=block$block$previousHash)
  
  #  list('message'='New block forged', c('index'= block$block$index, 'transactions'= block$block$transactions, 'nonce'=block$block$nonce,'previousHash'=block$block$previousHash))
}

#* @serializer custom_json
#* @post /nodes/register
#* @get /nodes/register
function(req, nodes)
{
  #  req_json <- '{"sender": "my address", "recipient": "someone else address", "amount": 5}'
  if (req$REQUEST_METHOD == "GET") {
    
  } else if (req$REQUEST_METHOD == "POST") {
    values <- jsonlite::fromJSON(req$postBody)
    nodes <-  values$nodes
  }  
  
  cat(paste0(nodes, "\n"))
  if (is.null(nodes)) {
    return("Error: the list of nodes is not valid")
  }
  
  blockchain$registerNode(nodes)
}

#* @serializer custom_json
#* @get /nodes/resolve
function (req)
{
  replaced = blockchain$handleConflicts()
  if (replaced) {
    list('message'='Replaced', 'chain' = blockchain$chain)
  } else  {
    list('message'='Authoritative block chain - not replaceable ', 'chain'=blockchain$chain)
  }
}

#* Log some information about the incoming request
#* @filter logger
function(req){
  cat(as.character(Sys.time()), "-", 
      req$REQUEST_METHOD, req$PATH_INFO, "-", 
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  plumber::forward()
}
