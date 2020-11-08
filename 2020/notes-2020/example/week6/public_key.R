# public_key.R
# FE8828
# Author: Yang Ye

# We are to use curve25519 in sodium.
# It is one of the fastest ECC curves and is not covered by any known patents.
# During the final episode of Silicon Valley (S06 E07), entitled "Exit Event",
# the fictional Pied Piper software was said to have cracked Curve25519
library(sodium)

# Private/public key
## Generate private/public key

# pubkey can be derived from key but not the opposite direction,
# which is asymmetric cryptography.
key <- keygen()
pub <- pubkey(key)
key
# you can share the pub with the recipient
pub

# Simple encryption

## serialize()/unserialize()
# iris is a data frame
# serialize() is to make it a stream (like cin/cout in C++) of bytes, ready to transmit.
# unserialize() is to restore from a stream
# No encrpytion during serialize/unserialize
msg <- serialize(head(iris), NULL)
msg
unserialize(msg)

## add encryption
msg_en <- simple_encrypt(msg, pub)
msg_en

unserialize(msg_en)

# restore iris
iris_restored <- unserialize(simple_decrypt(msg_en, key))
iris_restored

# Signature

## Generate signature to sign
sign_key <- sig_keygen()
sign_pubkey <- sig_pubkey(sign_key)

## Create signature with private key and verify it
msg <- serialize(head(iris), NULL)
unserialize(msg)
sig <- sig_sign(msg, sign_key)
sig

sig_verify(msg, sig, sign_pubkey)

## Build Global Key Signature

sign_key_A <- sig_keygen()
sign_pubkey_A <- sig_pubkey(sign_key_A)

sign_key_B <- sig_keygen()
sign_pubkey_B <- sig_pubkey(sign_key_B)

sign_key_C <- sig_keygen()
sign_pubkey_C <- sig_pubkey(sign_key_C)


## A and B submit their public signature to global register
sign_pubkey_register = list(
  'A' = sign_pubkey_A,
  'B' = sign_pubkey_B,
  'C' = sign_pubkey_C
)

sign_pubkey_register[['A']]

# A wants to send a transaction to B
create_msg <- function(tx, sign_key) {
  list(tx = tx,
       sig = sig_sign(serialize(tx, NULL), sign_key))
}

tx1 <- create_tx("A", "B", 3)
tx1_msg <- create_msg(tx1, sign_key_A)
tx1_msg

tx1_msg <- create_msg(tx1, sign_key_B)


# When everyone receives it
verify_tx <- function(tx_msg) {
  sign_pubkey <- sign_pubkey_register[[tx_msg$tx$sender]]
  (sig_verify(serialize(tx_msg$tx, NULL), tx_msg$sig, sign_pubkey))
}

verify_tx(tx1_msg)

# Bob wants to forge a transaction from Alice
# Unless Bob obtains Alice's sign_key_A, he can't do it.
# If he signs with his sign_key, validation can't be passed
tx2 <- create_tx("A", "C", 3)
tx2_msg <- create_msg(tx2, sign_key_B)
# tx2_msg

tryCatch({
  verify_tx(tx2_msg)  
}, error = function(err) {
  cat(paste0("Caugt the fraud transaction: ", as.character(err), "\n"))
})


