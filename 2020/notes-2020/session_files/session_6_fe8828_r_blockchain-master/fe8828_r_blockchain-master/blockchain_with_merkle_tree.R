# blockchain_with_merkle_tree.R
# FE8828 20191015

library(openssl)

calc_digest <- function(blk) {
  openssl::sha256(paste(paste0(blk), collapse = ","))
}

tx1 <- list(sender = "A",recipient = "B",amount = 1)
tx2 <- list(sender = "A",recipient = "B",amount = 1)
tx3 <- list(sender = "B",recipient = "C",amount = 2)
tx4 <- list(sender = "B",recipient = "C",amount = 2)

block0 <- list(digest = 0,
               content = list(
                 tx1,
                 tx2,
                 tx3,
                 tx4,
                 calc_digest(list(tx1, tx2)),
                 calc_digest(list(tx3, tx4)),
                 calc_digest(list(
                   calc_digest(list(tx1, tx2)),
                   calc_digest(list(tx3, tx4)))
                  )
                 
               )
)
block1 <- list(digest = calc_digest(block0),
               content = list(
                 sender = "B",
                 recipient = "C",
                 amount = 13
               ))
block2 <- list(digest = calc_digest(block1),
               content = list(
                 sender = "C",
                 recipient = "A",
                 amount = 12
               ))

blockchain <- list(block0, block1, block2)

tribble(
  ~sender, ~recipient, ~amount,
  "A", "B", 1,
  "B", "C", 13,
  "C", "A", 12
)
