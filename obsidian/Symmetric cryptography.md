Symmetric crypto uses the same key for encryption and decryption

# Block Cipher
Block ciphers are used in secure communication applications like TLS/HTTPs and IPsec, secure storage like BitLocker and Authentication like Kerberos.

In a nutshell block ciphers work by like this:
![[Pasted image 20260608113019.png]]
Initially, a random initialization vector and the first message block is encrypted via an ecryption scheme, here AES, with a key which then outputs the first cipher block. Then, the ouput is fed together with the second message block into the scheme to produce the second cipher block. This repeats until the whole plaintext is encrypted.

## Basic Properties
- D(K,E(K,P)) = P
	- Where K = key, P = plaintext
- blocksize 64 or 128 bit
- key size 128 or 256 bit

## Security goal
The encryption should be a [[Pseudo Random Function Family#Pseudo Random Permutation|Pseudo Random Permutation]] meaning that if the key is unknown, the output should be random and it is hard to guess the key given the ciphertext

## Design
How do we design a block cipher?

### Block size
When choosing block size, we have a trade off between CPU efficiency and security.
Smaller blocks are more CPU efficient but are less secure due to code book attacks.
Today, blocks are often 128 bit as they also fit into CPU register.

### Confusion and Diffusion
Confusion describes that the relation between input bits and output bits is complex.
Diffusion describes that changing one bit should change many (about half) output bits.
![[Pasted image 20260608160035.png]]

### Round paradigm
Instead of having one complex function, you can use a simpler function many times, each adding confusion and diffusion. The key is expanded each step.

### Feistel Network (DES)
The Feistel Network works by splitting the input block into two halves, running the left half through the F-Function and x-oring the output with the right side and using that ouput as the left input of the next round. 
![[Pasted image 20260608163724.png]]
The network does this 16 times. Every round, the key is rotated. Decryption works by doing the same process but with reverse key order.

#### F-Function
The function used by the feistel network is the key element adding confusion and diffusion.
It takes half of the block, 32 bits, and expands them to 48 bits to then xor it with part of the key (48 bit). Then 8 S-boxes replace 6 input bits into 4 output bits in a fixed manner, the selection of these S-boxes is very important as they ensure non-linearity. Finally, the 32 outputs from the S-boxes are rearranged according to a fixed permutation, the _P-box_. This is designed so that, after permutation, the bits from the output of each S-box in this round are spread across four different S-boxes in the next round.
![[Pasted image 20260608165330.png]]

### Triple DES
As DES was considered insecure due to a small key size, Triple-DES was introduced. Tripe-DES applies DES three times for a total key length of 168 bits which returnes 112 bits of security. However, Triple-DES is also deemed insecure by today.

### Substitution Permutation Network (AES)
The Substitution Permutation Network works by xor-ing the message block with the derived key (also uses a key for each round), running S-boxes over the block bits and finally run the permutation layer over the block bits, then it is passed onto the next round.
![[Pasted image 20260608171958.png]]
[[AES]] is one of the most commonly used Substitution Permutation Network 

#### Modes of operation
There are many ways block ciphers can be operated, mainly ECB, CBC and CTR
##### Electronic Codebook
ECB takes every message block and runs the block cipher over it, this is insecure as patterns remain visible in the ciphertext.
##### Cipher block chaining
CBC uses an IV, which is chosen randomly and sent along, and xor's it with the message block for the first round. After, the ouput of the previous cipher is the input of the current round.
In decryption, the process is reversed such that the first cipher block runs through the cipher operation and then it is xor-ed with the IV for the first round. After the cipher block of the previous round serves as the IV.

Because of the nonce, two encryptions of the same message look different and the message block is blinded with a random value (the output of the previous round). Essentially, the AES part acts as a pesudo random permutation
##### Counter mode
CTR uses a Nonce, which is sent along, and a counter, starting at 0, as the input message and runs AES over it. The output is xor-ed with the first message block to be the first cipher block. This is useful if we send data over an unreliable network since we can decrypt each message individually.

# Stream Cipher
Stream ciphers are used to encrypt messages in a stream, rather than breaking the message into a block.
This works by creating a key-stream of bits that is then xor-ed with the message bits. A Stream Cipher uses a Nonce, that is sent along, to make each encryption unique and a key.
Stream Ciphers are used because they are faster on hardware than block ciphers and padding oracle attacks are not possible.

## security
The security of a stream cipher can be reduced to producing a keystream that is indistinguishable from true randomness, similar to [[Pseudo Random Number Generators]]

## Types of stream ciphers
There are two types of stream ciphers, stateful and counter based:
![[Pasted image 20260609102401.png|495]]
Stateful starts with an initial state that is updated with each step and where the current step depends on the previous state. Counter based stream cipher work with a counter.
Counter based stream ciphers allow you to random access the cipher and also recover part of the cipher, which is not possible for stateful stream ciphers
## Feedback Shift Register
The goal of a feedback shift register is to build a machine that outputs pseudo-random bits which are easy to implement
### Linear Feedback Shift Register (LFSR)
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
#### Filtered LFSR
Filtered LFSR is where the output is a nonlinear function of the state bits.
![[Pasted image 20260609113019.png]]
Non-linear equations can be solved easily though making them predictable
### Non-Linear FSR
Non-Linear FSR are very hard to predict, however it is hard to compute the period of NFSR
## Grain-128a
Gran-128a is a lightweight stream-cipher composed of a NFSR and LFSR
![[Pasted image 20260609113422.png|322]]
## Salsa20
Salsa20 is a counter based stream cipher that works by running the key, a nonce and counter through a function and add the output of that function to the key, nonce and counter again. Then the plaintext is xor-ed with it.

the function (Quarter Round Fucntion) uses a ARX pattern: addition, rotation and xor, this function adds confusion and diffusion to the output

### ChaCha20
ChaCha20 is a modern variant of Salsa20 with a different QR function that adds more diffusion with a larger initial state such that nonce reusal is less likely

# Hash Functions
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
# Message Authentication
Message Authentication has the goal to provide an authentic channel. This means you can transmit data and provide proof that the data comes from you, like a signature. This works with a shared key

## Message Authentication Code
Message Authentication Code (MAC) is a keyed function that generates a fingerprint of a message based on a key. The message is then sent along the with the fingerprint as a tag through the channel. MACs are used in IPsec and TLS
### Security Properties
It should be infeasible to forge message authentication tags and it should be infeasible to derive the key from tags.
### Replay attacks
By default, MACs do not protect against replay attacks. Eve could replay a authentic message that Alice sent to Bob. Counters can be used in messages to prevent this.
### Hash-based MAC
Hash-based Message Authentication Code (HMAC) are essentially [[Pseudo Random Function Family|PRFs]] as we take a key and message as input and the output is deterministic but indistinguishable from random values.
A secure PRF is therefore a secure MAC. Designing a PRF for MAC is no simple task, since a hash function only takes one input but MAC takes two inputs, a key and message.
#### Design 1: Secret prefix
We can prefix the message with our key: $MAC(K,M)=H(K||M$ but this intrudes length extension attacks, not good.
#### Design 2: Secret-Suffix
We can add the secret as a suffix such that $MAC(K,M)=H(M||K)$ which prevents length-extension attacks. While this eliminates one problem, it requires usage of collision resistant hash functions which MD5 or SHA-1 is not.
#### Design 3: Envelope
We put the key before and after the message, preventing length extension attacks and making collisions less likely: $MAC(K,M)=H(K||M||K)$ 
This still requires that your hash function is collision resistant.
#### Design 4: HMAC
HMAC, as by RFC2104 incorporates two hashes such that $HMAC=H(k⊕OPAD|H(k⊕IPAD|m))$ 
OPAD is 5c5c…5c as long as the hash block length
IPAD is 3636…36 as long as the hash block length
![[Pasted image 20260609164646.png|417]]
