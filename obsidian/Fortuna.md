Fortuna is a [[Pseudo Random Number Generators]] used by macOS

The state consists of a 256 bit key **K** and a 128 bit counter **C**: State=(K,C). The initial state is (0,0).

# next() function
When the next() function of Fortuna is called it computes the AES hash of AES(K, C) and returns it as the value.
After, the counter C is incremented and the key K is updated by performing two more rounds of the next function where the key stays the same but the counter is incremented with each step. The new key **K'** consists of the of AES(K, C''') and AES(K, C'').
The next time next() is called the output consists of AES(K' and C').

# entropy pool
the entropy pool is used to reseed the key **K** from time to time. This is done by using the old key **K** and add information (entropy) from selected entropy pools and hash it, such that K' = SHA256(K||entropy pool information). It is important to have many entropy pools to ensure that there are some pools that an attacker cannot control.