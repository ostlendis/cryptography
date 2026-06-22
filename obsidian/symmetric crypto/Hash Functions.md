Hash functions can be used to obtain a fingerprint of data of any length. It is used in git versioning, malware fingerprinting, storage deduplication, blockchain and more.
A hash takes in input of any length and outputs a hash of fixed length.
Hash functions should be able to identify messages and make detecting changes easy.
## unpredictability
since hash functions can take more inputs than they can give outputs, collisions are unavoidable. So, as to make it hard to find these collisions, we want the output of a hash function to be unpredictable.
## Secure Hash functions
there are hash functions like CRC that are not suitable for cryptographic uses but can be useful in hashtables.
Secure hash functions, for cryptographic use, should satisfy certain conditions:
### Preimage resistance
Given a random output y of a hash function, it is infeasible to find input x such that $H(x)=y$ 
### Second Preimage Resistance
Given a random input x it is infeasible to find input $x'$ such that $H(x')=H(x)$  
### Collision Resistance
It is infeasable to find inputs $x$ and $x'$ such that $H(x')=H(x)$ 

It is possible for a hash function to be preimage resistant while not being collision resistant. For example for a preimage resistant hash function, we cannot reverse the hash of a birthday. Now we drop the first bit: it is still preimage resistant but by the birthday problem, the collision resistance is severely compromised because collisions are much easier to find now.
## Merkle-Damgård Construction
Merkle-Damgård Construction is compression based hashing. It is used by MD5 and SHA1/2
At its core it has a compression function F. It takes n bits input and has m bits output. The input message is split into blocks and together with an IV at the beginning or the previous output is ran through the compression function.
![[Pasted image 20260609135906.png|516]]
The padding introduces length extension attacks:
If a server computes ```token = MD5(secret || user_data)``` and we obtain the hash, we can compute a valid token for  ```token = MD5(user_data || padding || malicious_extension)``` without knowing the secret
### Compression Function
The compression function should have an output that looks random. For that we can use a block cipher:
![[Pasted image 20260609140635.png]]
## Sponge Construction
Sponge Construction is permutation based hashing and i used by SHA-3. It is resistant to length extension attacks and at it's core uses a [[Pseudo Random Function Family#Pseudo Random Permutation|PRP]] function.
![[Pasted image 20260609141040.png|613]]