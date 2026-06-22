Stream ciphers are used to encrypt messages in a stream, rather than breaking the message into a block.
This works by creating a key-stream of bits that is then xor-ed with the message bits. A Stream Cipher uses a Nonce, that is sent along, to make each encryption unique and a key.
Stream Ciphers are used because they are faster on hardware than block ciphers and padding oracle attacks are not possible.

# Security
The security of a stream cipher can be reduced to producing a keystream that is indistinguishable from true randomness, similar to [[Pseudo Random Number Generators]]

# Types of stream ciphers
There are two types of stream ciphers, stateful and counter based:
![[Pasted image 20260609102401.png|495]]
Stateful starts with an initial state that is updated with each step and where the current step depends on the previous state. Counter based stream cipher work with a counter.
Counter based stream ciphers allow you to random access the cipher and also recover part of the cipher, which is not possible for stateful stream ciphers
# Feedback Shift Register
The goal of a feedback shift register is to build a machine that outputs pseudo-random bits which are easy to implement
## Linear Feedback Shift Register (LFSR)
This works in three steps:
1. compute new bit as linear combination of current state
2. left-shift the current state and take the leftmost bit as the output
3. add the new bit to the right
![[Pasted image 20260609103815.png]]
Some combinations of taps and initial states produce cycles, such as the one above
![[Pasted image 20260609104006.png|632]]
The goal is to design a LFSR that has long cycles because short cycles are predictable.
We want to tap at least two bits and also tap the last output bit. There are methods to determine the maximal period of a LFSR where one method is to factor the LFSR polynomial:
If our taps are at position 4 and 2, we can write the LFSR as $X^{4}+X^{2}+1$ which becomes reducible to $X^{2}+X+1$, making the cycle shorter.
### Filtered LFSR
Filtered LFSR is where the output is a nonlinear function of the state bits.
![[Pasted image 20260609113019.png]]
Non-linear equations can be solved easily though making them predictable
## Non-Linear FSR
Non-Linear FSR are very hard to predict, however it is hard to compute the period of NFSR
# Grain-128a
Gran-128a is a lightweight stream-cipher composed of a NFSR and LFSR
![[Pasted image 20260609113422.png|322]]
# Salsa20
Salsa20 is a counter based stream cipher that works by running the key, a nonce and counter through a function and add the output of that function to the key, nonce and counter again. Then the plaintext is xor-ed with it.

the function (Quarter Round Fucntion) uses a ARX pattern: addition, rotation and xor, this function adds confusion and diffusion to the output
## ChaCha20
ChaCha20 is a modern variant of Salsa20 with a different QR function that adds more diffusion with a larger initial state such that nonce reusal is less likely
# [[Hash Functions]]
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