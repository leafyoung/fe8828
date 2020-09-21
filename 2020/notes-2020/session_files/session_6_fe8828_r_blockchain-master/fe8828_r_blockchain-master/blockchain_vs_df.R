# blockchain_vs_df.R
# FE8828 20191015

library(openssl)

calc_digest <- function(blk) {
  openssl::sha256(paste(paste0(blk), collapse = ","))
}

block0 <- list(digest = 0,
               content = list(
                 sender = "A",
                 recipient = "B",
                 amount = 123)
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

# If I use a simple database
tribble(
  ~sender, ~recipient, ~amount,
  "A", "B", 123,
  "B", "C", 13,
  "C", "A", 12
)

# Blockchain solution is much more complex but we gain
# 1) enforced order
# 2) integrity check from every transaction.
# Modifying an earlier transaction needs modification of all hashes thereafter.
