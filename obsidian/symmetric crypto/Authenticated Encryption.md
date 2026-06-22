Authenticated Encryption with Associated Data (AEAD) combines confidentiality with authenticity. This means we can establish a secure and authentic channel at the same time. This is achieved by combining ciphers for message encryption and MAC for signing.
## Secure channel from scratch
There are three main ways we can go about this:
1. Encrypt and MAC -> risk of leaking information since MAC is not built to hide information
2. MAC then encrypt -> was used in TLS but is vulnerable to padding oracle attacks
3. Encrypt then MAC -> provably secure, used in IPsec

| Encrypt and Mac                           | MAC then encrypt                          | Encrypt then MAC                          |
| ----------------------------------------- | ----------------------------------------- | ----------------------------------------- |
| ![[Pasted image 20260610154856.png\|291]] | ![[Pasted image 20260610154925.png\|247]] | ![[Pasted image 20260610154943.png\|186]] |
The overall construction goes as follows: encrypt the plaintext -> add MAC computed from cipher -> send over secure channel -> validate MAC -> decrypt cipher
## Associated Data
Often times a plain-text comes with additional data called associated data like network packet headers. The associated data is always public. AEAD ensures that the actual message is encrypted and the encrypted message plus the AD is authenticated:
![[Pasted image 20260610163824.png|378]]
## AES-GCM
AES in galios/counter mode is a block cipher AEAD standard that is used industry wide (TLS, SSH, IPsec). I encompasses two components:
- AES-CTR mode for message encryption
- GHASH for authentication, basically multiplication in a [[Algebraic structures for crypto#Finite Fields|Finite Field]] 
It is essential that the IV is unique.
AES-GCM is very fast on modern CPUs and can be parallelised

