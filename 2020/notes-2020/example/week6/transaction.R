# transaction.R
# FE8828
# Author: Yang Ye

# assign("last.warning", NULL, envir = baseenv())

# Run public_key.R before running this file

create_tx_signed <- function(sign_key,...) {
  if (any(is.na(sign_key))) {
    tx_signed <- list(tx = empty_tx, sig = NA)
    tx_signed
  } else {
    tx <- create_tx(...)    
    tx_signed <- create_msg(tx, sign_key)
    tx_signed
  }
}

tx1_signed <- create_tx_signed(sign_key_A, "A", "B", 3)
tx1_signed
verify_tx(tx1_signed)

tx2_signed <- create_tx_signed(sign_key_B, "B", "A", 14)
verify_tx(tx2_signed)

tx3_signed <- create_tx_signed(sign_key_C, "C", "A", 7)
verify_tx(tx3_signed)

empty_tx_signed <- create_tx_signed(NA, NA)
empty_tx_signed

create_block_pow_signed <- function(prev_digest,tx1=empty_tx_signed,tx2=empty_tx_signed,tx3=empty_tx_signed,tx4=empty_tx_signed,difficulty)
{
  # verify transaction are signed correctly
  if (! any(is.na(tx1$sig))) { verify_tx(tx1) }
  if (! any(is.na(tx2$sig))) { verify_tx(tx2) }
  if (! any(is.na(tx3$sig))) { verify_tx(tx3) }
  if (! any(is.na(tx4$sig))) { verify_tx(tx4) }

  # Create merkle tree
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

blk1 <- create_block_pow_signed(digest_genesis, tx1_signed, tx2_signed, difficulty = 3)

val_block_pow_signed <- function(blk) {
  if (! any(is.na(blk$txs$tx1$sig))) { verify_tx(blk$txs$tx1) }
  if (! any(is.na(blk$txs$tx2$sig))) { verify_tx(blk$txs$tx2) }
  if (! any(is.na(blk$txs$tx3$sig))) { verify_tx(blk$txs$tx3) }
  if (! any(is.na(blk$txs$tx4$sig))) { verify_tx(blk$txs$tx4) }

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

val_block_pow_signed(blk1)

# Difficulty can be adjusted between blocks
blk1 <- create_block_pow_signed(digest_genesis,tx1_signed,difficulty = 1)
blk2 <- create_block_pow_signed(blk1$digest,tx2_signed,difficulty = 2)
blk3 <- create_block_pow_signed(blk2$digest,tx3_signed,difficulty = 3)
val_block_pow_signed(blk1)
val_block_pow_signed(blk2)
val_block_pow_signed(blk3)

bc <- create_chain(blk1, blk2, blk3)
val_chain(bc, val_block_pow_signed)
