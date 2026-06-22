Block ciphers are used in secure communication applications like TLS/HTTPs and IPsec, secure storage like BitLocker and Authentication like Kerberos.

In a nutshell block ciphers work by like this:
![[Pasted image 20260608113019.png]]
Initially, a random initialization vector and the first message block is encrypted via an ecryption scheme, here AES, with a key which then outputs the first cipher block. Then, the ouput is fed together with the second message block into the scheme to produce the second cipher block. This repeats until the whole plaintext is encrypted.

# Basic Properties
- D(K,E(K,P)) = P
	- Where K = key, P = plaintext
- blocksize 64 or 128 bit
- key size 128 or 256 bit

# Security goal
The encryption should be a [[Pseudo Random Function Family#Pseudo Random Permutation|Pseudo Random Permutation]] meaning that if the key is unknown, the output should be random and it is hard to guess the key given the ciphertext

# Design
How do we design a block cipher?

## Block size
When choosing block size, we have a trade off between CPU efficiency and security.
Smaller blocks are more CPU efficient but are less secure due to code book attacks.
Today, blocks are often 128 bit as they also fit into CPU register.

## Confusion and Diffusion
Confusion describes that the relation between input bits and output bits is complex.
Diffusion describes that changing one bit should change many (about half) output bits.
![[Pasted image 20260608160035.png]]
## Round paradigm
Instead of having one complex function, you can use a simpler function many times, each adding confusion and diffusion. The key is expanded each step.
## Feistel Network (DES)
The Feistel Network works by splitting the input block into two halves, running the left half through the F-Function and x-oring the output with the right side and using that ouput as the left input of the next round. 
![[Pasted image 20260608163724.png]]
The network does this 16 times. Every round, the key is rotated. Decryption works by doing the same process but with reverse key order.

### F-Function
The function used by the feistel network is the key element adding confusion and diffusion.
It takes half of the block, 32 bits, and expands them to 48 bits to then xor it with part of the key (48 bit). Then 8 S-boxes replace 6 input bits into 4 output bits in a fixed manner, the selection of these S-boxes is very important as they ensure non-linearity. Finally, the 32 outputs from the S-boxes are rearranged according to a fixed permutation, the _P-box_. This is designed so that, after permutation, the bits from the output of each S-box in this round are spread across four different S-boxes in the next round.
![[Pasted image 20260608165330.png]]

## Triple DES
As DES was considered insecure due to a small key size, Triple-DES was introduced. Tripe-DES applies DES three times for a total key length of 168 bits which returnes 112 bits of security. However, Triple-DES is also deemed insecure by today.

## Substitution Permutation Network (AES)
The Substitution Permutation Network works by xor-ing the message block with the derived key (also uses a key for each round), running S-boxes over the block bits and finally run the permutation layer over the block bits, then it is passed onto the next round.
![[Pasted image 20260608171958.png]]
[[AES]] is one of the most commonly used Substitution Permutation Network 

### Modes of operation
There are many ways block ciphers can be operated, mainly ECB, CBC and CTR
#### Electronic Codebook
ECB takes every message block and runs the block cipher over it, this is insecure as patterns remain visible in the ciphertext.
#### Cipher block chaining
CBC uses an IV, which is chosen randomly and sent along, and xor's it with the message block for the first round. After, the ouput of the previous cipher is the input of the current round.
In decryption, the process is reversed such that the first cipher block runs through the cipher operation and then it is xor-ed with the IV for the first round. After the cipher block of the previous round serves as the IV.

Because of the nonce, two encryptions of the same message look different and the message block is blinded with a random value (the output of the previous round). Essentially, the AES part acts as a pesudo random permutation
#### Counter mode
CTR uses a Nonce, which is sent along, and a counter, starting at 0, as the input message and runs AES over it. The output is xor-ed with the first message block to be the first cipher block. This is useful if we send data over an unreliable network since we can decrypt each message individually.