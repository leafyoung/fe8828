# pow.R
# FE8828
# Author: Yang Ye

# Run merkle_tree.R before running this file
# Proof of Work

create_block_pow <- function(prev_digest,tx1=empty_tx,tx2=empty_tx,tx3=empty_tx,tx4=empty_tx,difficulty) {
  mkl_from_txs <- create_mkl_tree(tx1, tx2, tx3, tx4)
 
  # pow
  now <- Sys.time()
  nonce <- 0
  while(TRUE) {
    timestamp <- Sys.time()
    # It's necessary to embed nonce, difficulty, time stamp into the digest so it can be self-verified.  
    try_digest <- calc_digest(list(nonce, difficulty, timestamp, prev_digest, tail(mkl_from_txs$mkl,1)))
    zero_prefix <- paste0(rep("0",difficulty),collapse = "")
    if (substr(try_digest,1,difficulty) == zero_prefix) {
      break
    } else {
      nonce <- nonce + 1
    }
  }
  cat(paste0("PoW: ", round(as.numeric(difftime(Sys.time(), now, unit="s")),3), "s Nonce: ", nonce, "\n"))
  
  list(prev_digest = prev_digest,
       timestamp = timestamp,
       nonce = nonce,
       difficulty = difficulty,       
       digest = calc_digest(list(nonce, difficulty, timestamp, prev_digest, tail(mkl_from_txs$mkl,1))),
       txs = mkl_from_txs$txs,
       mkl = mkl_from_txs$mkl)
}

val_block_pow <- function(blk) {
  mkl_from_txs <- do.call("create_mkl_tree", blk$txs)
  assert(all(mkl_from_txs$mkl[1] == blk$mkl[1]))
  
  # pow
  zero_prefix <- paste0(rep("0",blk$difficulty),collapse = "")
  assert(substr(blk$digest,1,blk$difficulty) == zero_prefix)

  # It's necessary to embed nonce, difficulty, time stamp into the digest so it can be self-verified.  
  blk_digest <- calc_digest(list(blk$nonce, blk$difficulty, blk$timestamp, blk$prev_digest, tail(mkl_from_txs$mkl,1)))
  assert(blk_digest == blk$digest)
  
  cat(paste0("Block passed validation: ", blk$digest, "\n"))
}

blk_with_diff_1 <- create_block_pow(digest_genesis,tx1,difficulty = 1)
blk_with_diff_1$digest
val_block_pow(blk_with_diff_1)

blk_with_diff_2 <- create_block_pow(digest_genesis,tx1,difficulty = 2)
blk_with_diff_2$digest
val_block_pow(blk_with_diff_2)

blk_with_diff_3 <- create_block_pow(digest_genesis,tx1,difficulty = 3)
blk_with_diff_3$digest
val_block_pow(blk_with_diff_3)

# this is to take longer time, disable for now
if (FALSE) {
  blk_with_diff_4 <- create_block_pow(digest_genesis,tx4,difficulty = 4)
  blk_with_diff_4$digest
  val_block_pow(blk_with_diff_4)
  
  blk_with_diff_5 <- create_block_pow(digest_genesis,tx4,difficulty = 5)
  blk_with_diff_5$digest
  val_block_pow(blk_with_diff_5)
}

# Difficulty can be adjusted between blocks
blk1 <- create_block_pow(digest_genesis,tx1,difficulty = 1)
blk2 <- create_block_pow(blk1$digest,tx2,difficulty = 2)
blk3 <- create_block_pow(blk2$digest,tx3,difficulty = 3)
val_block_pow(blk1)
val_block_pow(blk2)
val_block_pow(blk3)

bc <- create_chain(blk1, blk2, blk3)
val_chain(bc, val_block_pow)
