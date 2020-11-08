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

tx1 <- create_tx("A","B",10)

blk1 <- list(
  txs = list(tx1),
  hash = digest_genesis
)

tx2 <- create_tx("B","A",10)

blk2 <- list(
  txs = list(tx2),
  prev_hash = digest_genesis,
  hash = calc_digest(paste0(digest_genesis, list(tx2)))
)

blk1$hash == blk2$prev_hash
calc_digest(paste0(digest_genesis, list(tx2))) == blk2$hash

#
list(tx1, tx2, tx3, tx4, tx5)




