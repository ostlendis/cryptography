In contrast to symmetric encryption, asymmetric encryption uses different keys for en- and decryption. We use a public key for encryption and a private key for decryption. For example, if Bob has a public and private key, he publicises his public key. I can then encrypt my secret message with his public key and only Bob can read whats in it because he is the only person having the corresponding private key.
Because asymmetric encryption is usually much slower than symmetric encryption it is not used for everything even tough needing a shared key seems limiting.
We can however use asymmetric encryption to encrypt an AES key which we can then use for faster symmetric encryption.
# RSA
RSA allows for encryption and signing of messages. These processes are not the same. Encryption uses the public key and subsequent decryption the private key. Signing uses the private key and subsequent verification the public key.
## Modulus
RSA works by modulus. We multiply two large prime numbers $p$ and $q$ together to get part of the public key $n$: $$n = pq$$Choose $e$ such that $e$ is co-prime to $\varphi(n)$. Publicise $n$ and $e$ as your **public key**. The **private key** $d$ is computed as: 
$$ed \equiv 1 \pmod{\varphi(n)}$$
## Encryption 
$$y = x^e \mod n$$
## Decryption 
$$x = y^d \mod n$$ This works because: $$y^d = (x^e)^d = x^{ed} = x^{1+q\varphi(n)} = x \cdot (x^{\varphi(n)})^q = x \cdot 1 = x$$So in order for an attacker to break the scheme, they need $d$, and for that they need $\varphi(n)$, which requires factoring $n$.
## Example
$$p=3,\ q=11,\ n=33,\ \varphi(n)=20,\ e=3,\ d=7$$
**Encrypt** $x = 2$: $$y = 2^3 \mod 33 = 8$$**Decrypt:** $$x = 8^7 \mod 33 = 2 \ \checkmark$$
Since implementing RSA on your own is not easy, it is recommended to use well established libraries. RSA only allows encrypting messages smaller than the key size.
# ElGamal Encryption
ElGamal Encryption exploits the hardness in the descrete logarithm problem over groups.
Let $G$ be a group of prime order $q$ and $g$ a generator.
We generate a public key $pk$ which is a random number from 0 to q-1 and calculate the private key $pk=g^{sk}$ 
## Encryption
1. Map the message $m$ to a group element $M$
2. choose $r$ as a random number from 0 to q-1
3. return $c=(g^r,M*pk^r)=(c1, c2)$ 
## Decryption
1. compute $s=c1^{sk}$
2. $M=c2*s^{-1}$
3. Map M to message m
![[Pasted image 20260611143234.png]]
## Decisional Diffie Hellman
DDH assumes that for random $a$ and $b$ in 0 to q-1, the value $g^{ab}$ in generator $G$ looks like a random element, can be defined as a security game.
ElGamal can be reduced to the DDH game and is therefore IND-CPA