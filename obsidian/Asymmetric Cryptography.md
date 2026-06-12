# Hard Problems
In a nutshell, hard problems are tasks that are easy to do/compute one way, but very difficult or infeasible to reverse. This is useful if we want to use a cryptographic scheme between two persons and it is very hard for an attacker to attack this scheme because the scheme encompasses a hard problem.
Computational problems are problems that can be solved with a program or algorithm such as sorting an array, factoring a number or finding the best route from point A to B.

There are multiple types of hard problems:
## Descision Problem
Some problems can be formulated as a yes-no question, for example "is the number 42 prime?" and some problems cannot be answered (Halting-problem).
## Functional Problem
A functional problem is a problem where the answer is a function of a given input and not a simple yes/no answer. Examples are the travelling salesman problem where the answer is the path or a factorisation problem where the answer is a list of factors.
## Optimisation/Approximation Problem
Optimisation/Approximation problems are problems where we want to find the best solution or at least an approximation. Examples are finding a timetable, maximum of a given function and machine learning.
## Running time
We want to measure running time of an algorithm to estimate how many operation it takes to calculate something. For example, a nested for-loop is of running time $O(n^2)$ where n is the input size in bits.
### Solvable problem?
If a computational problem is solvable depends on its runtime:
- $O(n)$ is feasaible to compute
- $O(2^n)$ is practially impossible to compute
- $O(n²)$ is in between
#### Polynomial Time
Problems that can be solved in polynomial time are considered "efficient" in cryptography and can be solved in a reasonable time. It would have a runtime of $O(n^k)$ for some $k$. Examples are sorting a list, multiplying numbers or database searches.
#### Super-Polynomial Time
Problems where adding few bits to the input (like key size) makes computing the solution take much longer than the heat death of the universe are in super-polynomial time. It would have a runtime that grows faster than any polynomial like $O(2^n)$. In cryptography, these problems are deemed "inefficient". Examples, as of now, are number factoring, time tables and solving sudokus.
## Complexity classes
### P
complexity class P includes all problems that can be solved in $O(n^k)$ running time for all constant k. This means that P contains problems that can be solved in polynomial time.
### PSPACE
Complexity calls PSPACE contains all problems that can be solved in $O(n^k)$ memory size. This means that PSPACE contains all problems that can be solved with a polynomial amount of memory.
### NP
Non-deterministic polynomial time includes problems where a solution can be verified efficiently, but finding the solution may still be hard, for example: does there exist $K$ such that $C=AES(K,P)$ for a given $C,P$?
### NP-Completeness
NP-Complete problems include problems that are harder than NP-Problems. If we can find a solution to solve a NP-complete problem, we have solved all NP problems in polynomial time.
## Important hard problems
These problems are used in cryptography
### Factoring
Given a number n, provide a decomposition into prime factors. There is only one solution.
The naïve algorithm(N) is to test for x in 2..sqrt(N) if x is dividable by N. This results in a runtime of $O(n^{n/2})$. While there are algorithms to make it more efficient, the time is still exponential.
Since we assume that factoring is a hard problem, we can build cryptographic schemes:
$N = p*q$ for primes p and q. Our public key is N and our secret is p and q. This scheme is used in RSA
### Discrete Logarithm
Discrete logarithm uses [[Algebraic structures for crypto#Groups|Groups]]. Groups have operations that are closed, meaning that an operation on an element of a group results in that group again.
A generator is an element $g$ in group $G$ where $ord(g)=ord(G)$. This means that every element in the group $G$ can be written as a multiple of $g$.

The problem goes as follows: given a group $G=(\mathbb{Z}_p^*, *)$ and a generator $g$ and an input y, find k such that $g^k=y$ 
As we assume that finding $k$ is a hard problem, we can build cryptographic schemes with it. If we have a generator $g$ we can use $y=g^k$ where y is our public key and k our secret key. This is used in elliptic curve cryptography. It is important to note that you have to use specific large subgroups for $G$ as others may be trivially to solve.
# Asymmetric Ciphers
In contrast to symmetric encryption, asymmetric encryption uses different keys for en- and decryption. We use a public key for encryption and a private key for decryption. For example, if Bob has a public and private key, he publicises his public key. I can then encrypt my secret message with his public key and only Bob can read whats in it because he is the only person having the corresponding private key.
Because asymmetric encryption is usually much slower than symmetric encryption it is not used for everything even tough needing a shared key seems limiting.
We can however use asymmetric encryption to encrypt an AES key which we can then use for faster symmetric encryption.
## RSA
RSA allows for encryption and signing of messages. These processes are not the same. Encryption uses the public key and subsequent decryption the private key. Signing uses the private key and subsequent verification the public key.
### Modulus
RSA works by modulus. We multiply two large prime numbers $p$ and $q$ together to get part of the public key $n$: $$n = pq$$Choose $e$ such that $e$ is co-prime to $\varphi(n)$. Publicise $n$ and $e$ as your **public key**. The **private key** $d$ is computed as: 
$$ed \equiv 1 \pmod{\varphi(n)}$$
### Encryption 
$$y = x^e \mod n$$
### Decryption 
$$x = y^d \mod n$$ This works because: $$y^d = (x^e)^d = x^{ed} = x^{1+q\varphi(n)} = x \cdot (x^{\varphi(n)})^q = x \cdot 1 = x$$So in order for an attacker to break the scheme, they need $d$, and for that they need $\varphi(n)$, which requires factoring $n$.
### Example
$$p=3,\ q=11,\ n=33,\ \varphi(n)=20,\ e=3,\ d=7$$
**Encrypt** $x = 2$: $$y = 2^3 \mod 33 = 8$$**Decrypt:** $$x = 8^7 \mod 33 = 2 \ \checkmark$$
Since implementing RSA on your own is not easy, it is recommended to use well established libraries. RSA only allows encrypting messages smaller than the key size.
## ElGamal Encryption
ElGamal Encryption exploits the hardness in the descrete logarithm problem over groups.
Let $G$ be a group of prime order $q$ and $g$ a generator.
We generate a public key $pk$ which is a random number from 0 to q-1 and calculate the private key $pk=g^{sk}$ 
### Encryption
1. Map the message $m$ to a group element $M$
2. choose $r$ as a random number from 0 to q-1
3. return $c=(g^r,M*pk^r)=(c1, c2)$ 
### Decryption
1. compute $s=c1^{sk}$
2. $M=c2*s^{-1}$
3. Map M to message m
![[Pasted image 20260611143234.png]]
### Decisional Diffie Hellman
DDH assumes that for random $a$ and $b$ in 0 to q-1, the value $g^{ab}$ in generator $G$ looks like a random element, can be defined as a security game.
ElGamal can be reduced to the DDH game and is therefore IND-CPA

# Key exchange
Exchanging keys is no trivial task. Sending over a insecure channel enables man in the middle attacks. We need an authentic channel first to exchange keys so we can verify they come from the person we expect. But authentic channels with [[Symmetric cryptography#Message Authentication|message authentication]] requires keys? This is solved using signatures.
![[Pasted image 20260611161321.png|610]]
## Key Exchange Protocol
KEy Exchange Protocol (KEX) enables exchanging keys by both parties contributing to the key.
## Key Encapsulation Mechanism
Key Encapsulation Mechanism (KEM) enables exchanging keys by one party generating the key and encrypted and sent to the other party.
# Elliptic Curves
Elliptic Curves have the function $y^2=x^3+ax+b$. This function is known as the Weierstrass equation though there are other equations that produce elliptic curves.
![[Pasted image 20260611164322.png|627]]
Elliptic curves over a [[Algebraic structures for crypto#Finite Fields|finite field]] look like a random point cloud
![[Pasted image 20260611164452.png]]
## Elliptic Curve Groups
In a group, we have to define the add function $+$. In elliptic curves this is defined as drawing a line through point $P$ and $Q$ and mirror the point where it intersects with the function again to get $R$
Doubling points, such that $R=2P$ is done mirroring the point where the tangent at point $P$ intersects the function.
If the line does not intersect the function, it goes to infinity and the value computes to $P$

An Elliptic Curve Group (ECG) must satisfy these three axioms:
1. $P+(Q+R)=(P+Q)+R$
2. Neutral element is infinity
3. Each point $P$ has an inverse mirrored at the x-axis
### Scalar Multiplication
Let $P$ be a point and $k$ a scalar, we multiply point $P$ $k$ times, can be done fast by double-and-add
### Finite Field ECG
In a finite field, addition works by drawint the line and wrapping around until you hit a point.
![[Pasted image 20260611175224.png|344]]
### Notational difference
ECG: $(E,+)$
Group: $(\mathbb{Z}_p^*,\cdot)$
## Elliptic Curve DLP
The cryptographic scheme now comes from the desecrete logarithm problem: Given points $P$ and $G$, find $k$ such that $P=kG$. For specific elliptic curves over finite fields, we believe this problem to be very hard.
## Advantage
the advantage from Elliptic curve cryptography comes from its key size. For 128 bits of security, elliptic curves require 256 bits key size where RSA requires 3072 bits.
## EC Diffie-Hellman Key Exchange
Elliptic curves allow key exchange when Alice generates a random $a$ and sends $A=aG$ over an authentic channel. Bob also generates a random $b$, calculates $B=bG$ and sends it over the authentic channel. Alice now knows her private key $a$ and bobs $B$ and Bob knows his private key $b$ and Alice's public key $A$ and such have now a shared secret: $abG=aB=bA$
An attacker in the network only ever knows $A$ and $B$.
![[Pasted image 20260612093826.png|422]]
## Security
We know that that the Discrete Logarithm Problem is harder than Computational Diffie-Hellman which is harder than Decisional Diffie Hellman. So: DLP harder than CDH harder than DDH. If we break DLP, we also break DDH
### ECDH
If CDH holds on the curve, the attacker cannot learn the full shared secret tough he could learn part of the shared secret. If the DDH assumption holds, the shared secret is indistinguishable from a random curve point.
The shared secret $abG$ is not a random bit-string, therefore we use $H(abG)$ as our key
# Signatures
The problem from building a authentic channel arises from shared keys. We can share keys if we have an authentic channel with RSA or Elliptic curves. We have a chicken and egg problem: can we build an authentic channel from an insecure channel?
## Public Key Infrastructure
Public Key Infrastructure (PKI) allows us to bind a unique public key to each party which is validated by X.509 certificates issued by certificate authorities.
With this, Alice can send a message signed by her private key and bob can verify the signature with the public key validated by a certificate authority.
## Signature Schemes
There are many different signature schemes.
### Hash-then-Sign
Since signing is computationally heavy, we usually hash our message and then sign the hash, this gives us predicable computational work.
### Security properties
Signature schemes must meet these properties:
- Correctness - Valid signatures always pass verification
- Integrity - Any message alteration invalidates the signature
- Unforgeability - Signatures are computationally infeasible to fake
- Authenticity - Confirms the identity of the sender
- Non-repudiation - Signers cannot deny signing the message
### EUF-CMA
Existential Unforgeability under Chosen Message Attack has the benefit of being hard to forge even if you have seen many signatures.
This leaves open an attack surface where one can forge a signature for a message that is different to the original signature but also valid. This is known as transaction malleability where it lead to multiple transactions made by users, spending money twice.
### SUF-CMA
Strong Existential Unforgeability under Chosen Message Attack closes the transaction malleability issue
### ECDSA
Elliptic curve digital signature algorithm is based on elliptic curve cryptography.
#### Key generation
ECDSA generates key in these steps:
First, we chose a elliptic curve in a finite field $C(F)$ and choose a base point $G$ in the curve. We also chose a prime $n$ in the order of group $G$. 
$C(F)$, $G$ and $n$ are public parameters

We generate our private key by choosing $d$ from our finite field in $n$ and calculate our public key $P=dG$ 

#### Signing
We sign our message by hashing the message and interpret the result as $h$ in our finite field in $n$. We select random $k$ from our finite field and get $(x,y)=kG$. We compute $r=x\mod n$ and $s=(h+rd)k^{-1}\mod n$. Our signature composes $(r,s)$.
#### Verification
We hash the message and interpret it again as a number in the finite field over $n$
We compute $u=hs^{-1}\mod n$ and compute $v=rs^{-1}\mod n$. We calculate $(x',y') = uG+vP$ and check if $x=r$.
### Ed25519
Ed25519 is a scheme that is also a elliptic curve based signature. It requires no nonce and is faster than standard ECDSA.
#### Key generation
For key generation we first choose public parameters similar to ECDSA $pp=(C,G,n)$.
Then we chose a private key $k$ which is a random bitstring of usually length 256.
Using SHA-512 we generate two halves from our key: $a||h=H(k)$ our public key is $P=aG$ and we use $h$ for signing
#### Signing
To sign, we compute $r=H(h||m)$ and $R=rG$ in addition to $S=r+H(R||P||m)a\mod n$. Our signature represents the curve point plus a number: $(R,S)$
#### Verification
To verify, we compute $H(R||P||m)$ and check if it is equal to $SG=R+H(R||P||m)P$
