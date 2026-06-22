Elliptic Curves have the function $y^2=x^3+ax+b$. This function is known as the Weierstrass equation though there are other equations that produce elliptic curves.
![[Pasted image 20260611164322.png|627]]
Elliptic curves over a [[Algebraic structures for crypto#Finite Fields|finite field]] look like a random point cloud
![[Pasted image 20260611164452.png]]
# Elliptic Curve Groups
In a group, we have to define the add function $+$. In elliptic curves this is defined as drawing a line through point $P$ and $Q$ and mirror the point where it intersects with the function again to get $R$
Doubling points, such that $R=2P$ is done mirroring the point where the tangent at point $P$ intersects the function.
If the line does not intersect the function, it goes to infinity and the value computes to $P$

An Elliptic Curve Group (ECG) must satisfy these three axioms:
1. $P+(Q+R)=(P+Q)+R$
2. Neutral element is infinity
3. Each point $P$ has an inverse mirrored at the x-axis
## Scalar Multiplication
Let $P$ be a point and $k$ a scalar, we multiply point $P$ $k$ times, can be done fast by double-and-add
## Finite Field ECG
In a finite field, addition works by drawint the line and wrapping around until you hit a point.
![[Pasted image 20260611175224.png|344]]
## Notational difference
ECG: $(E,+)$
Group: $(\mathbb{Z}_p^*,\cdot)$
# Elliptic Curve DLP
The cryptographic scheme now comes from the desecrete logarithm problem: Given points $P$ and $G$, find $k$ such that $P=kG$. For specific elliptic curves over finite fields, we believe this problem to be very hard.
# Advantage
the advantage from Elliptic curve cryptography comes from its key size. For 128 bits of security, elliptic curves require 256 bits key size where RSA requires 3072 bits.
# EC Diffie-Hellman Key Exchange
Elliptic curves allow key exchange when Alice generates a random $a$ and sends $A=aG$ over an authentic channel. Bob also generates a random $b$, calculates $B=bG$ and sends it over the authentic channel. Alice now knows her private key $a$ and bobs $B$ and Bob knows his private key $b$ and Alice's public key $A$ and such have now a shared secret: $abG=aB=bA$
An attacker in the network only ever knows $A$ and $B$.
![[Pasted image 20260612093826.png|422]]
# Security
We know that that the Discrete Logarithm Problem is harder than Computational Diffie-Hellman which is harder than Decisional Diffie Hellman. So: DLP harder than CDH harder than DDH. If we break DLP, we also break DDH
## ECDH
If CDH holds on the curve, the attacker cannot learn the full shared secret tough he could learn part of the shared secret. If the DDH assumption holds, the shared secret is indistinguishable from a random curve point.
The shared secret $abG$ is not a random bit-string, therefore we use $H(abG)$ as our key