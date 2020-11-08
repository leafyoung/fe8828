# merkle_tree.R
# FE8828
# Author: Yang Ye

# This file shows how to build blockchain.

# Setup

library(tibble)
library(openssl)
library(testit)

# Digest function

btc_hash <- function(x) {
  openssl::sha256(openssl::sha256(x))
}

calc_digest <- function(blk) {
  btc_hash(paste(paste0(blk), collapse = ","))
}

digest_genesis <- calc_digest('Genesis')

# Merkle Tree

create_mkl_tree <- function(tx1, tx2, tx3, tx4) {
  list(
    txs = list(tx1=tx1,tx2=tx2,tx3=tx3,tx4=tx4),
    mkl = c(
      calc_digest(tx1),
      calc_digest(tx2),
      calc_digest(tx3),
      calc_digest(tx4),
      calc_digest(list(tx1, tx2)), # H_AB
      calc_digest(list(tx3, tx4)), # H_CD
      calc_digest(list( # H_AB, H_CD => H_ABCD
        calc_digest(list(tx1, tx2)),
        calc_digest(list(tx3, tx4)))
      )
    )
  )
}

# Transaction

create_tx <- function(sender,recipient,amount) {
  Sys.sleep(0.0001)
  if (is.na(sender) | is.na(recipient) | is.na(amount)) {
    list(sender = NA,
         recipient = NA,
         amount = NA,
         timestamp = NA)
  } else {
    list(sender = sender,
         recipient = recipient,
         amount = amount,
         timestamp = Sys.time())
  }
}

empty_tx <- create_tx(NA,NA,NA)
empty_tx

# Block

## Create block

create_block <- function(prev_digest,tx1=empty_tx,tx2=empty_tx,tx3=empty_tx,tx4=empty_tx) {
  mkl_from_txs <- create_mkl_tree(tx1, tx2, tx3, tx4)
  timestamp <- Sys.time()
  nonce <- 0
  
  list(prev_digest = prev_digest,
       timestamp = timestamp,
       nonce = nonce, # 0
       txs = mkl_from_txs$txs,
       mkl = mkl_from_txs$mkl,
       # onnce, timestamp, prev_diget, H_ABCD
       digest = calc_digest(list(nonce, timestamp, prev_digest, tail(mkl_from_txs$mkl,1))))
}

tx1 <- create_tx("A","B",1)
tx2 <- create_tx("A","B",2)
tx3 <- create_tx("B","C",3)
tx4 <- create_tx("B","C",4)

block0 <- create_block(digest_genesis, tx1, tx2, tx3, tx4)
block0

## Space saving through Merkle tree.

object.size(block0$txs)
object.size(block0$mkl)

tx5 <- create_tx("B","C",13)

block1 <- create_block(block0$digest,tx5)

tx6 <- create_tx("C","A",12)

block2 <- create_block(block1$digest,tx6)

## Validate block

val_block <- function(blk) {
  mkl_from_txs <- do.call("create_mkl_tree", blk$txs)
  assert(all(mkl_from_txs$mkl[1] == blk$mkl[1]))
  assert(all(mkl_from_txs$mkl[2] == blk$mkl[2]))
  assert(all(mkl_from_txs$mkl[3] == blk$mkl[3]))
  assert(all(mkl_from_txs$mkl[4] == blk$mkl[4]))
  assert(all(mkl_from_txs$mkl[5] == blk$mkl[5]))
  assert(all(mkl_from_txs$mkl[6] == blk$mkl[6]))
  assert(all(mkl_from_txs$mkl[7] == blk$mkl[7]))
  
  blk_digest <- calc_digest(list(blk$nonce, blk$timestamp, blk$prev_digest, tail(mkl_from_txs$mkl,1)))
  assert(blk_digest == blk$digest)
  
  cat(paste0("Block passed validation: ", blk$digest, "\n"))
}

val_block(block0)
val_block(block1)
val_block(block2)

if (FALSE) {
  block0_dup <- block0
  block0_dup$digest <- "asdfadsf"
  val_block(block0_dup)
  
  block0_dup$txs <- list(tx4, tx4, tx4, tx4)
  val_block(block0_dup)
  
  block0_dup$txs <- list(tx1, tx3, tx4, tx2)
  val_block(block0_dup)
}

## Create chain

create_chain <- function(...) {
  list(...)
}

bc0 <- create_chain(block0, block1, block2)

bc0

## Validate chain

# val_chain: does two things
# 1. blk1$hash == blk2$prev_hash
# 2. all block are self-validated.

val_chain <- function(bc, val_func) {
  genesis_digest <- digest_genesis
  first_blk <- TRUE
  tryCatch({
    for (b in bc) {
      if (first_blk) {
        first_blk <- FALSE      
        prev_digest <- genesis_digest
        prev_timestamp <- 0
      } else {
        assert(b$prev_digest == prev_digest)
      }
      assert(prev_timestamp < b$timestamp)
      val_func(b)
      prev_digest <- b$digest
      prev_timestamp <- b$timestamp
    }
  }, error = function(err) {
    cat(paste0("Chain failed validation", as.character(err), "\n"))
    stop(err)
  })
  cat(paste0("Chain passed validation\n"))
}

val_chain(bc0, val_block)

# A Wrong chain from a wrong block

bc1 <- create_chain(block0, block2)

tryCatch({
  val_chain(bc1, val_block)
}, error = function(err) {
  cat(paste0("Caught the wrong blockchain"))
})

# Find a transaction

# To find a past transaction
find_tx <- function(bc, tx) {
  tx_digest <- calc_digest(tx)
  for (b in bc) {
    if (tx_digest %in% b$mkl[1:4]) {
      return(TRUE)
    }
  }
  return(FALSE)
}

find_tx(bc0, tx1)
find_tx(bc0, create_tx("A", "B", 123))

# In tibble, simple, but with no protection at all
library(dplyr)
bind_rows(tx1,tx2,tx3,tx4,tx5,tx6)

# Blockchain is much more complex but we gain
# 1) Enforced order
# 2) Integrity check from every transaction.
# 3) Modifying an earlier transaction needs modification of all hashes thereafter.
