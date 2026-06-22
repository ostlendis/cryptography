Pseudo Random Function Family (PRF) is a family of functions that given a key and input it generates a deterministic ouput. If the key is not known, the ouput looks random.
We do not know if PRF's exist, however we believe that SHA-256 HMAC is one. 

# Key Derivation Function 
Key Derivation Functions (KDF) can be used to deterministically create new keys from a given key. Is used in IPsec VPN and WPA2/3 Wireless authentication. PRF's can be used as a KDF like Argon2 uses it.
Other applications are crypto wallets where the seed phrase allows for reconstruction of the wallets secret key
# Pseudo Random Permutation 
Pseudo Random Permutation (PRP) is a bijective PRF where there are no collisions for inputs for a given key and every output has a pre-image. We believe that AES is a PRP.