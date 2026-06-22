Message Authentication has the goal to provide an authentic channel. This means you can transmit data and provide proof that the data comes from you, like a signature. This works with a shared key.
# Message Authentication Code
Message Authentication Code (MAC) is a keyed function that generates a fingerprint of a message based on a key. The message is then sent along the with the fingerprint as a tag through the channel. MACs are used in IPsec and TLS
## Security Properties
It should be infeasible to forge message authentication tags and it should be infeasible to derive the key from tags.
## Replay attacks
By default, MACs do not protect against replay attacks. Eve could replay a authentic message that Alice sent to Bob. Counters can be used in messages to prevent this.
## Hash-based MAC
Hash-based Message Authentication Code (HMAC) are essentially [[Pseudo Random Function Family|PRFs]] as we take a key and message as input and the output is deterministic but indistinguishable from random values.
A secure PRF is therefore a secure MAC. Designing a PRF for MAC is no simple task, since a hash function only takes one input but MAC takes two inputs, a key and message.
### Design 1: Secret prefix
We can prefix the message with our key: $MAC(K,M)=H(K||M$ but this intrudes length extension attacks, not good.
### Design 2: Secret-Suffix
We can add the secret as a suffix such that $MAC(K,M)=H(M||K)$ which prevents length-extension attacks. While this eliminates one problem, it requires usage of collision resistant hash functions which MD5 or SHA-1 is not.
### Design 3: Envelope
We put the key before and after the message, preventing length extension attacks and making collisions less likely: $MAC(K,M)=H(K||M||K)$ 
This still requires that your hash function is collision resistant.
### Design 4: HMAC
HMAC, as by RFC2104 incorporates two hashes such that $HMAC=H(k⊕OPAD|H(k⊕IPAD|m))$ 
OPAD is 5c5c…5c as long as the hash block length
IPAD is 3636…36 as long as the hash block length
![[Pasted image 20260609164646.png|417]]
This pattern retains security even if the hash function $H$ hast structural weakness like SHA-1. It is secure as long as the compression function is a PRF.
## CMAC
CMAC is block-cipher based message authentication and therefore uses a block cipher as the building block. It is similar to CBC-Mode but the last block is processed differently and only the last cipher is kept.
![[Pasted image 20260610110519.png|341]]
## Dedicated MAC Design
To improve efficiency, we design a dedicated MAC. Cryptographic hash functions offer stronger guarantees than we need for MAC, like SHA-2 is collision resistant but we would only need PRF-like compression. This is acceptable because the attacker does not know the key so even if he finds collisions, they would not work without knowing the key.
### Universal Hashing
A universal hash has two inputs: key $K$ and message $M$. The function is designed such that the probability of $UH(K,m)=UH(K,M')$ is negligible. This hash is easier to satisfy than being a full PRF while being fast to evaluate.
### One-Time MAC
Other designs employ using a key only once, since using it multiple times could leak information about the key. This implementation uses a universal hash and is very fast to run.

Poly1305-AES builds on top of this by adding AES encryption to the one-time MAC using two keys and a nonce:
$MAC(K1,K2,N,M) = UH(K1,M)+AES(K2,N)$