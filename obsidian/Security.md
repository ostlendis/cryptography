In order to ensure that any cryptographic scheme is actually secure, we need multiple things:

- Precise Definitions
- Precise Assumptions
- An attacker Model
- Security Proofs

# Precise Definitions
be precise about the definitions used, go actually know what you want to achieve in a measurable way, for example:
```“Attacker should not be able to recover the key”  ```
is not precise, it leaves many questions open like is recovering the plaintext ok?
It should be:
```
“Independent of any information the attacker already knows, the
ciphertext should not leak additional information about the
underlying plaintext”
```

# Precise Assumptions
We need precise assumptions to compare different schemes like RSA and ECDSA. Assumptions should be well tested.
The assumption "Factoring is hard" can be further defined as for large enough numbers, someone is unlikely to factor a number in a reasonable time frame

# Attacker Model
Define the capabilities of an attacker like computational limits and attack vectors like eavesdropping, message tampering and budgets (cannot corrupt more than 1/3 of parties)

# Security Proof
For the given assumptions and the defined attacker model, provide a rigorous proof that the scheme holds. 

Proofs can be made by reducing the problem and providing proof by contradiction.

Lets say we have a schema T that is secure and we want to prove that schema S is secure. We assume that schema S is breakable and then provide a converter that lets us convert schema T into a game of schema S. Since we know schema T is secure, S must be secure as well.

# Real-World Security
We want to measure the security of AES-128 encryption.
For this, we can use the computational security model. It has two parameters:
- t - limit on the number of operations of the attacker
- ε - limit on the success probability

A scheme s (t, ε)-secure when the probability of success after t steps is smaller than ε
For example a perfect 64 bit block cipher is (t, t/$2^{64}$)-secure for t in \[1, $2^{64}$\]

With this, we can measure security in bits. For the example above, we have 64 bits of security.
Key length of a scheme is an upper bound of security though, for example, RSA with 2800-bit keys only provides 120 bits of security and AES-128 provides 120 bits of security.

