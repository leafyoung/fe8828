# public_key.R
# FE8828 20191015
library(sodium)

# Generate private/public key
# pubkey can be derived from key but not the opposite direction,
# which is asymmetric cryptography.
key <- keygen()
pub <- pubkey(key)
key
pub

# Use key to do simple encryption
msg <- serialize(iris, NULL)
unserialize(simple_decrypt(simple_encrypt(msg, pub), key))

# generate signature to sign
sign_key <- sig_keygen()
sign_pubkey <- sig_pubkey(sign_key)

# Create signature with private key
msg <- serialize(iris, NULL)
sig <- sig_sign(msg, sign_key)
print(sig)

# A wants to send a message to B
msg <- list(
     body = list(sender = "A", recipient = "B", amount = 3),
     sig = sig_sign(serialize(list(sender = "A", recipient = "B", amount = 3), NULL), sign_key))

# B
sig_verify(serialize(msg$body, NULL), msg$sig, sign_pubkey)
