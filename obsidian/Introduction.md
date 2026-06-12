This course is split into 4 categories:

- [[Randomness]] and random number generation
- [[Symmetric cryptography]] 
- [[Asymmetric cryptography]]
- [[Posts-Quantum Cryptography]]

## Encryption Attacker Model
To determine what good enough encryption is, we have to define the assumed attacker. There are two main attacker models:
- CPA - The attacker can perform encryption queries
	- For example PGP encryption with a public key
- CCA - The attacker can perform encryption and decryption queries
	- For example TLS connection where we can encrypt messages and observe the response
## Encryption Security Goals
There are two separate security goals:
- Indistinguishability (IND)
	- Ciphertext for different messages should look the same (random)
- Nonmalleability (NM)
	- Given a cipher-text, it should be impossible to create a cipher-text for a related message without knowing the key
## Semantic Security
The security goal and attacker model can be combined:
- IND-CPA 
	- Indistinguishability in the CPA model, meaning the cipher-text should not leak any information if the key is secret
- IND-CCA 
	- Indistinguishability in the CCA model, the attacker can also make encryption queries
- NM-CPA
- NM-CCA