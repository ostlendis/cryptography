The problem from building an authentic channel arises from shared keys. We can share keys if we have an authentic channel with RSA or Elliptic curves. We have a chicken and egg problem: can we build an authentic channel from an insecure channel?
# Public Key Infrastructure
Public Key Infrastructure (PKI) allows us to bind a unique public key to each party which is validated by X.509 certificates issued by certificate authorities.
With this, Alice can send a message signed by her private key and bob can verify the signature with the public key validated by a certificate authority.
# Signature Schemes
There are many different signature schemes.
## Hash-then-Sign
Since signing is computationally heavy, we usually hash our message and then sign the hash, this gives us predicable computational work.
## Security properties
Signature schemes must meet these properties:
- Correctness - Valid signatures always pass verification
- Integrity - Any message alteration invalidates the signature
- Unforgeability - Signatures are computationally infeasible to fake
- Authenticity - Confirms the identity of the sender
- Non-repudiation - Signers cannot deny signing the message
## EUF-CMA
Existential Unforgeability under Chosen Message Attack has the benefit of being hard to forge even if you have seen many signatures.
This leaves open an attack surface where one can forge a signature for a message that is different to the original signature but also valid. This is known as transaction malleability where it lead to multiple transactions made by users, spending money twice.
## SUF-CMA
Strong Existential Unforgeability under Chosen Message Attack closes the transaction malleability issue
## ECDSA
Elliptic curve digital signature algorithm is based on elliptic curve cryptography.
### Key generation
ECDSA generates key in these steps:
First, we chose a elliptic curve in a finite field $C(F)$ and choose a base point $G$ in the curve. We also chose a prime $n$ in the order of group $G$. 
$C(F)$, $G$ and $n$ are public parameters

We generate our private key by choosing $d$ from our finite field in $n$ and calculate our public key $P=dG$ 

### Signing
We sign our message by hashing the message and interpret the result as $h$ in our finite field in $n$. We select random $k$ from our finite field and get $(x,y)=kG$. We compute $r=x\mod n$ and $s=(h+rd)k^{-1}\mod n$. Our signature composes $(r,s)$.
### Verification
We hash the message and interpret it again as a number in the finite field over $n$
We compute $u=hs^{-1}\mod n$ and compute $v=rs^{-1}\mod n$. We calculate $(x',y') = uG+vP$ and check if $x=r$.
## Ed25519
Ed25519 is a scheme that is also a elliptic curve based signature. It requires no nonce and is faster than standard ECDSA.
### Key generation
For key generation we first choose public parameters similar to ECDSA $pp=(C,G,n)$.
Then we chose a private key $k$ which is a random bitstring of usually length 256.
Using SHA-512 we generate two halves from our key: $a||h=H(k)$ our public key is $P=aG$ and we use $h$ for signing
### Signing
To sign, we compute $r=H(h||m)$ and $R=rG$ in addition to $S=r+H(R||P||m)a\mod n$. Our signature represents the curve point plus a number: $(R,S)$
### Verification
To verify, we compute $H(R||P||m)$ and check if it is equal to $SG=R+H(R||P||m)P$
