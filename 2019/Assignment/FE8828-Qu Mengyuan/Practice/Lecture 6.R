install.packages("openssl")
library(openssl)
sha256("123")
sha256("1234")
  
calc_digest <-function(blk){
  sha256(paste(paste0(blk), collapse = ","))
}

tx1 <- list(sender = "A",recipient = "B",amount = 1)
tx2 <- list(sender = "A",recipient = "B",amount = 1)
tx3 <- list(sender = "B",recipient = "C",amount = 2)
tx4 <- list(sender = "B",recipient = "C",amount = 2)

block0 <- list(digest = 0,
               content = list(
                 tx1,tx2,tx3,tx4,
                 calc_digest(list(tx1,tx2)),
                 calc_digest(list(tx3,tx4)),
                 calc_digest(list(
                   calc_digest(list(tx1,tx2)),
                   calc_digest(list(tx3,tx4)),
                 )),
               ))
block1 <- list(digest = calc_digest(block0),
               content = list(
                 sender = "B",
                 recipient = "C",
                 amount = 13
               ))
block2 <- list(digest = calc_digest(block0),
               content = list(
                 sender = "C",
                 recipient = "A",
                 amount = 12
               ))

blockchain <- list(block0,block1,block2)

tibble(
  ~senderm ~recipient, ~amount,
  "A","B",123,
  "B","C",13,
  "C","A",12)

library(sodium)

key <- keygen()
pub <- pubkey(key)
key
pub

key <-sig_keygen()
pubke <- sig_pubkey()

msg <- serialize(iris,NULL)
sig <- sig_sign(msg, key)
print(sig)

msg <- list(
  body = list(sender = "A", recipient = "B", amount = 3),
  sig = sig_sign(serialize(list()))
)