# FE8828 Blockchain class

# Blockchain example
# {
#   "index": 2,
#   "timestamp": 1514108190.2831,
#   "transactions": [{
#     "sender": "d4ee26eee15148ee92c6cd394edd964",
#     "recipient": "23448ee92cd4ee26eee6cd394edd964",
#     "amount": 15
#   }, {
#     "sender": "6eee15148ee92c6cd394edd974d4ee2",
#     "recipient": "15148ee92cd4ee26eee6cd394edd964",
#     "amount": 225
#   }],
#   "nonce": 211,
#   "previousHash": "afb49032c6c086445a1d420dbaf88e4925681dec0a5b660d528fe399e557bf68"
# }

list.of.packages <- c("digest", "httr","jsonlite")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(digest)
library(jsonlite)
library(httr)

Blockchain <- function ()
{
  bc = list (
    chain = list(),
    currentTransactions  = list(),
    nodes = list()
  )

  #' Create a new Block in the Blockchain
  #'
  #' @param nonce <int> The nonce given by the Proof of Work algorithm
  #' @param previousHash <str> Hash of previous Block
  #' @return new block generated given the \code{nonce} and the \code{previousHash}
  #' @examples  
  #' blockchain = Blockchain()
  #' blockchain$nextBlock(previousHash=1, nonce=100) # genesis block

  bc$nextBlock = function (nonce, previousHash=NULL){
    previousHash <- ifelse (is.null(previousHash),
                            bc$hashBlock(bc$chain[length(bc$chain)]),
                            previousHash)
    
    block <- list('block' = list('index' = length (bc$chain) + 1,
                 'timestamp' = as.numeric(Sys.time()),
                 'transactions' =  bc$currentTransactions,
                 'nonce' = nonce,
                 'previousHash' = previousHash))
    
    bc$currentTransactions <- NULL
    bc$chain <- append(bc$chain, block)
    return (block)
  }

  #' Returns the last block in the Blockchain
  #'
  #' @examples  
  #' blockchain$lastBlock()
  bc$lastBlock = function () {
    bc$chain[length(bc$chain)]
  }

  #' Register a new transaction in the Blockchain
  #'
  #' @param sender <str> address of the sender
  #' @param recipient <str> address of the recipient
  #' @param amount <int> transaction amount
  #' @return  <int> Index of the Block that will hold this transaction
  bc$addTransaction <- function (sender, recipient, amount) 
  {
    txn <-  list('transaction'= list('sender'=sender,'recipient'=recipient,'amount'=amount))
    bc$currentTransactions <- append(bc$currentTransactions, txn)
    last.block <- bc$lastBlock()
    return(last.block$block$index + 1)
  }

  #' Hash a block using SHA256
  #'
  #' @param block <block> 
  #' @return  <str> SHA256 hashed value for \code(block)
  #' @examples  
  bc$hashBlock <- function (block) {
    require(digest)
    digest(block, algo="sha256")
  }
  
  #' Find a number p' such that hash(pp') that ends with two zeroes, where p is the previous p'
  #' p is the previous nonce and p' is the new nonce
  #' @param last_nonce <block> 
  #' @return <str> SHA256 hashed value for \code(block)
  bc$proofOfWork <- function (last_nonce)
  {
    nonce <- 0
    while (!bc$validNonce(last_nonce, nonce)) {
      nonce <- nonce + 1
    }
    return(nonce)
  }

  #' Find a number p' such that hash(pp') ends with two zeroes, where p is the previous p'
  #' p is the previous nonce and p' is the new nonce
  #' @param last_nonce <int> previous nonce
  #' @param nonce <int> nonce
  #' @return <bool> TRUE if correct, FALSE if not
  bc$guessProof <- function(last_nonce, nonce){
    guess <- paste0(last_nonce, nonce)
    guess_hash <- digest(guess, algo = 'sha256')
    guess_hash
  }
  
  bc$validNonce <- function (last_nonce, nonce) 
  {
    guess_hash <- bc$guessProof(last_nonce, nonce)
    return (gsub('.*(.{2}$)', '\\1',guess_hash) == "00")
  }

  #' Checks whether a given blockchain is valid
  #'
  #' @return  <bool> TRUE if the chain is valid, FALSE otherwise
  bc$validChain <- function (chain)
  {
    lastBlock <- chain[0]
    currentIndex <- 1
    while (currentIndex < length(chain))
    {
      block = chain[currentIndex]
      # checking for valid linking
      if (block$block$previousHash != bc$hashBlock(lastBlock)) {
        return(FALSE)
      }
      # checking for nonce validity
      if(!bc$validNonce(lastBlock$block$nonce, block$block$nonce)) {
        return(FALSE)
      }
      lastBlock <- block
      currentIndex <- currentIndex +1
    }
    return(TRUE)
  }

  #' Add a new node to the list of existing nodes
  #' 
  #' @param address <str> full URL of the node  
  #' @examples  
  #' blockchain = Blockchain()
  #' blockchain$registerNode('http://192.168.0.5:5000')
  bc$registerNode <- function(address)
  {
    parsed_url <- address
    if (length(bc$nodes) > 0) {
      if (! (parsed_url %in% bc$nodes != "")) {
        bc$nodes<- append(bc$nodes, parsed_url)
        TRUE
      } else {
        FALSE
      }
    } else {
      bc$nodes<- append(bc$nodes, parsed_url)
      TRUE
    }
  }
  
  #' Resolve conflicts by replacing the current chain by the longest chain in the network
  #'
  #' @return  <bool> TRUE if the chain was replaced, FALSE otherwise
  bc$handleConflicts <- function()
  {
    neighbours <- bc$nodes 
    new_chain <- NULL
    max_length <- length(bc$chain)
    for (i in 1:length(neighbours))
    {
      chain.node <- GET(paste0(neighbours[i],'/chain'))
      node.chain.length <- jsonlite::fromJSON(chain.node)$length
      node.chain.chain <- jsonlite::fromJSON(chain.node)$chain
      if (node.chain.length > max_length)
      {
        new_chain = node.chain.chain
        max_length<-node.chain.length
      }
    }
    if (!is.null(new_chain))
    {
      bc$chain <- new_chain 
    }
  }
  # Adding bc to the environment
  bc <- list2env(bc)
  class(bc) <- "BlockchainClass"
  return(bc)
}
