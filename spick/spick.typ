#import "template_zusammenf.typ": *

#show: project.with(
  authors: "Silvan Lendi",
  fach: "CRY",
  fach-long: "Cryptography",
  semester: "FS26",
  language: "en",
  column-count: 5,
  font-size: 4pt,
  landscape: true,
)

= Security

*Attacker Models:*
_CPA_ #hinweis[(can perform encryption queries, e.g. PGP with public key)],
_CCA_ #hinweis[(can perform encryption + decryption queries, e.g. TLS)]\
*Security Goals:*
_IND (Indistinguishability)_ #hinweis[(ciphertexts for different messages look random/same)],
_NM (Nonmalleability)_ #hinweis[(impossible to create ciphertext for related message without key)]\
*Semantic Security* combines goal + model:\
_IND-CPA_ #hinweis[(ciphertext leaks no info if key is secret)],
_IND-CCA_ #hinweis[(IND against attacker who can also make decryption queries)],
_NM-CPA_ #hinweis[(can't forge cipher for related message knowing only the cipher)],
_NM-CCA_ #hinweis[(can't forge cipher knowing cipher + able to make decryption queries)]

= Randomness

*Why it matters:* Cryptography requires unpredictable secrets, nonces & IVs — without unpredictability, crypto is impossible.\
*Good randomness:* Uniform distribution = _low entropy_. _Shannon entropy_ measures the "surprise factor" of a distribution — lower entropy = more predictable.\
*Problem on PCs:* Entropy sources (user input, temperature, lava lamps) are non-uniform or too slow.\
*PRNG* #hinweis[(Pseudo Random Number Generator)]: Fast, indistinguishable from true randomness. Seeded — same seed → same output.\
*PRF* #hinweis[(Pseudo Random Function Family)]: Deterministic output from key + input — same key & input → same output, but looks random.

== PRNG
*Security:* Must use _cryptographic_ PRNGs for crypto. Requires:\
_Prediction-resistance_: given output sequence, next output is unpredictable.\
_Backtracking-resistance_: given output sequence, previous state is unrecoverable.\


#table(
  columns: (1fr, 1fr),
  stroke: none,
  inset: 0pt,
  text(fill: black)[
    *Operation:* State machine — state feeds generator, part of output feeds back into state. State seeded from entropy pool.\
    `init()` init pool, `refresh(r)` add entropy, `next(n)` output $n$ random bits
  ],

  image("images/randomness_state_machine.png")
)
== PRF
_Pseudo Random Function Family_: key + input → deterministic output; looks random if key unknown. Believed example: SHA-256 HMAC.\
*KDF* #hinweis[(Key Derivation Function)]: deterministically derives new keys from a given key #hinweis[(IPsec, WPA2/3, Argon2, crypto wallets — seed phrase reconstructs secret key)].\
*PRP* #hinweis[(Pseudo Random Permutation)]: bijective PRF — no collisions, every output has a pre-image. Believed example: AES.

= Symmetric Cryptography
Same key for encryption & decryption. Primitives: _Block Cipher_ #hinweis[(plaintext → random-looking ciphertext, reversible)], _Stream Cipher_ #hinweis[(random string XORed with stream)], _Hash_ #hinweis[(fingerprint of data)], _MAC_ #hinweis[(tamper-proof channel)], _AEAD_ #hinweis[(encryption + auth; associated data authenticated but not encrypted)].

== Block Cipher
Used in TLS/HTTPS, IPsec, BitLocker, Kerberos. $D(K,E(K,P))=P$. Block: 128 bit, Key: 128/256 bit.\

#box[
  #grid(
    columns: (1fr, 0.45fr),
    gutter: 1em,

    [
      *Security goal:* Output is a _PRP_ — looks random, key hard to guess from ciphertext.\
      *Block size trade-off:* smaller = faster but vulnerable to codebook attacks; 128 bit fits CPU registers.\
      *Confusion:* complex relation between input/output bits.
      *Diffusion:* 1 input bit change → ~half output bits change.
      *Round paradigm:* simple function repeated many times,
      key expanded each round.
    ],

    [
      #image("images/block_cipher_diffusion.png", width: 100%)
    ]
  )
]

*Round paradigm:* simple function repeated many times, key expanded each round.

=== Feistel Network (DES)
Split block into halves $L,R$. Each round: $L' = R,\ R' = L \oplus F(R, K_i)$. 16 rounds, key rotated each round. Decrypt = same process, reversed key order.\
#image("images/feistel_network.png")
#table(
  columns: (1fr, 1fr),
  stroke: none,
  inset: 0pt,

  text(fill: black)[
    *F-Function:* 32 bit → expand to 48 bit → XOR with 48-bit subkey →
    8 _S-boxes_ (6→4 bit, non-linear) → _P-box_ permutation
    (spreads each S-box output across 4 S-boxes next round).

    *3DES:* DES×3, 168-bit key → 112-bit security.
  ],

  image("images/f_function.png", width: 100%),
)

=== Substitution Permutation Network (AES)
Each round: XOR block with round key → S-boxes → permutation layer → next round.
#image("images/aes_substitution_permutation_network.png")
==== AES
128-bit block, operates on bytes arranged in $4 times 4$ matrix. Rounds:\
_KeyExpansion_: derives 128-bit round key each round.\
_SubBytes_: S-box per byte — only non-linear step, protects against linear attacks.\
_ShiftRows_: row $i$ shifted by $i$ positions.\
_MixColumns_: each column multiplied by fixed matrix → every input byte affects every output byte.\
_AddRoundKey_: each byte XORed with round key.\
ShiftRows + MixColumns add diffusion and are easily reversible. Implemented via lookup tables or hardware; most modern CPUs have native AES instructions.
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  image("images/aes_subbytes.png"),
  image("images/aes_shiftrows.png"),

  image("images/aes_mixcolumns.png"),
  image("images/aes_addroundkey.png")
)
==== Modes of Operation
_ECB_: each block encrypted independently — *insecure*, patterns visible in ciphertext.\
_CBC_: random IV XORed with first block; each cipher block feeds next round. Decrypt: reverse, XOR with previous cipher block. Same message encrypts differently each time.\
#image("images/aes_cbc.png")
_CTR_: AES(Nonce ∥ counter) XORed with message block. Each block independently decryptable — good for unreliable networks.

== Stream Cipher
Keystream XORed with message bits. Uses key + nonce (sent along) for uniqueness. Faster than block ciphers on hardware; no padding oracle attacks.\
*Security:* keystream must be indistinguishable from true randomness (→ PRNG).\
*Stateful:* each step depends on previous state; no random access.\
*Counter-based:* counter as input; allows random access & partial recovery #hinweis[(e.g. CTR mode)].\
#image("images/stream_cipher_types.png")
*LFSR* #hinweis[(Linear Feedback Shift Register)]: new bit = linear combination of state; left-shift, output leftmost bit, append new bit. Goal: maximize cycle length — factor 
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  image("images/lfsr.png"),
  image("images/lfsr_cycles.png"),
)

#box[
  #grid(
    columns: (1fr, 0.45fr),
    gutter: 1em,

    [
      LFSR polynomial to check #hinweis[($X^4+X^2+1$ reducible → shorter cycle)].

      _Filtered LFSR_: nonlinear function of state bits, but still solvable.\ 

      *NFSR:* hard to predict but period hard to compute. *Grain-128a:* lightweight cipher = NFSR + LFSR.\
      Salsa20: counter-based; $inline(F(text("key"), text("nonce"), text("ctr")))$ + add back input → XOR with plaintext.
      Quarter Round uses ARX (add, rotate, XOR) for confusion + diffusion.
      *ChaCha20:* Salsa20 variant with stronger QR, larger initial state → less likely nonce reuse.

      #image("images/grain-128a.png", width: 50%)
    ],

    [
      #image("images/lfsr_filtered.png", width: 100%)
    ]
  )
]


== Hash Functions
Any-length input → fixed-length fingerprint. Used in git, malware detection, deduplication, blockchain.\
Collisions unavoidable (more inputs than outputs) → output must be *unpredictable*. CRC not suitable for crypto.\
*Preimage resistance:* given $y$, infeasible to find $x$ s.t. $H(x)=y$.\
*2nd preimage resistance:* given $x$, infeasible to find $x' \neq x$ s.t. $H(x')=H(x)$.\
*Collision resistance:* infeasible to find any $x \neq x'$ s.t. $H(x)=H(x')$.\
#hinweis[Preimage resistant ⇏ collision resistant: dropping 1 bit keeps preimage resistance but birthday problem makes collisions easy.]

=== Merkle-Damgård #hinweis[(MD5, SHA-1/2)]
Compression function $F$: $n$ bits in, $m$ bits out. Message split into blocks, chained through $F$ with IV. Block cipher can implement $F$.\
#image("images/merkle_damgard_construction.png")
*Length extension attack:* knowing $H(text("secret") || text("data"))$, an attacker can compute a valid
$H(text("secret") || text("data") || text("pad") || text("ext"))$
without knowing the secret.
=== Sponge Construction #hinweis[(SHA-3)]
Permutation-based; uses PRP at core. *Resistant to length extension attacks.*
#image("images/sponge_construction.png")

== Message Authentication
Goal: authentic channel — proof data comes from sender. Uses shared key.\
*MAC* #hinweis[(Message Authentication Code)]: keyed function → tag = fingerprint of message sent alongside it. Used in IPsec, TLS.\
*Security:* infeasible to forge tags or derive key from tags.\
*Replay attacks:* MACs don't protect by default — Eve can replay valid messages. Fix: include counters.

=== HMAC
MACs are essentially PRFs: key + message → deterministic but random-looking output. Secure PRF = secure MAC.\
_Secret prefix_ $H(K || M)$: vulnerable to length extension.\
_Secret suffix_ $H(M || K)$: no length extension, but requires collision-resistant hash.\
_Envelope_ $H(K || M || K)$: better, still needs collision resistance.\
_HMAC_ (RFC 2104): $H(K xor "OPAD" | H(K xor "IPAD" | M))$ — two hashes, OPAD = `5c5c…`, IPAD = `3636…` (block-length). Secure even with structurally weak $H$; only needs PRF compression function.
#image("images/hmac_pattern.png", width: 70%)

=== CMAC
Block-cipher based MAC, similar to CBC-mode but last block processed differently; only last cipherblock kept.


=== Dedicated MAC
Crypto hash functions give stronger guarantees than needed — PRF-like compression suffices since attacker doesn't know the key (collisions useless without it).\
*Universal Hash:* $"UH"(K, M)$: $Pr["UH"(K,M) = "UH"(K,M')] approx 0$. Easier than full PRF, fast to evaluate.\
*One-Time MAC:* key used only once (reuse leaks key info). Uses universal hash, very fast.\
*Poly1305-AES:* $"MAC"(K_1, K_2, N, M) = "UH"(K_1, M) + "AES"(K_2, N)$ — one-time MAC + AES with two keys and nonce.

== Authenticated Encryption (AEAD)
Combines confidentiality + authenticity in one. Associated Data (AD) #hinweis[(e.g. network headers)] is public, authenticated but *not* encrypted.\
*Encrypt-and-MAC:* risk of leaking info — MAC not designed to hide data.\
*MAC-then-Encrypt:* used in TLS — vulnerable to padding oracle attacks.\
*Encrypt-then-MAC:* provably secure, used in IPsec. ✓\
Overall: encrypt plaintext → MAC over ciphertext → send → validate MAC → decrypt.
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  image("images/aead_mac_then_encrypt.png"),
  image("images/aead_encrypt_and_mac.png"),

  image("images/aead_encrypt_then_mac.png"),
  image("images/associated_data.png"),

)

=== AES-GCM
Industry standard AEAD #hinweis[(TLS, SSH, IPsec)]. Two components:\
_AES-CTR_: message encryption.\
_GHASH_: authentication via finite field multiplication.\
IV *must* be unique. Fast on modern CPUs, fully parallelisable.

== Hard Problems
Easy one way, infeasible to reverse. Used to build cryptographic schemes.\
Types: _Decision_ #hinweis[(yes/no, e.g. "is 42 prime?", Halting problem undecidable)], _Functional_ #hinweis[(answer is a value, e.g. factoring, TSP path)], _Optimisation_ #hinweis[(best/approx solution, e.g. timetable, ML)].\
*Feasibility:* $O(n^k)$ polynomial = feasible #hinweis[(sorting, DB search, multiplication)]; $O(2^n)$ super-polynomial = infeasible #hinweis[(factoring, sudoku)].\
*Complexity classes:* _P_: solvable in $O(n^k)$. _NP_: solution verifiable in poly time, finding it may be hard #hinweis[(e.g. does $K$ exist s.t. $C=text("AES")(K,P)$?)]. _NP-Complete_: solving one solves all NP problems in poly time. _PSPACE_: solvable with $O(n^k)$ memory.\
*Factoring:* given $n$, find primes $p,q$ s.t. $n=p q$. Only one solution. Naïve: test all $x in [2, sqrt(N)]$ → $O(n^(n\/2))$; faster algorithms exist but still exponential. RSA: public key $n$, secret $p,q$.\
*Discrete Log:* group $G=(ZZ_p^*, *)$, generator $g$ #hinweis[(every element in $G$ is a multiple of $g$)], find $k$ s.t. $g^k=y$. Public key $y=g^k$, secret $k$. Must use specific large subgroups — small ones trivially solvable.

== Asymmetric Ciphers
Public key encrypts, private key decrypts. Much slower than symmetric → typically only used to encrypt a symmetric key #hinweis[(e.g. AES key)] for a hybrid scheme.

=== RSA
Supports both encryption+decryption and signing+verification (not the same operation).\
*Setup:* $n=p q$ for large primes $p,q$. Choose $e$ coprime to $phi(n)=(p-1)(q-1)$. Public key: $(n,e)$. Private key: $d$ s.t. $e d equiv 1 mod(phi(n))$.\
*Encrypt:* $y=x^e mod n$. *Decrypt:* $x=y^d mod n$.\
*Correctness:* $y^d=(x^e)^d=x^(e d)=x^(1+q phi(n))=x dot (x^(phi(n)))^q=x dot 1=x$.\
*Security:* breaking requires $d$ → needs $phi(n)$ → requires factoring $n$.\
#hinweis[Example: $p=3, q=11, n=33, phi(n)=20, e=3, d=7$. Enc $x=2$: $y=2^3 mod 33=8$. Dec: $8^7 mod 33=2$ ✓]\
Only encrypts messages smaller than key size. Use established libraries — own implementation risky.

=== ElGamal
Based on hardness of discrete log. Group $G$ of prime order $q$, generator $g$. Choose random $s k in [0,q-1]$, compute $p k=g^(s k)$.\
*Enc:* map $m → M$ as group element; choose random $r in [0,q-1]$; return $(c_1, c_2)=(g^r, M dot p k^r)$.\
*Dec:* compute $s=c_1^(s k)$, recover $M=c_2 dot s^(-1)$, map $M → m$.\
*DDH assumption:* for random $a,b$, $g^(a b)$ is indistinguishable from a random group element. ElGamal security reduces to DDH → IND-CPA secure.
#image("images/elgamal.png", width: 80%)

== Key Exchange
Authentic channel needed to prevent MITM — but authentic channels need shared keys. Chicken-and-egg problem solved by asymmetric crypto + signatures.\
#image("images/building_secure_channel.png", width: 0%)
*KEX* #hinweis[(Key Exchange Protocol)]: both parties contribute randomness to derive a shared key.\
*KEM* #hinweis[(Key Encapsulation Mechanism)]: one party generates key, encrypts with recipient's public key and sends it.

== Elliptic Curves
Defined by Weierstrass equation $y^2=x^3+a x+b$. Over finite fields: looks like a random point cloud.\
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,

  image("images/finite_field_ecg.png", width: 100%),
  image("images/elliptic_curve_finite_field.png")
)
#table(
  columns: (1fr, 1fr),
  stroke: none,
  inset: 0pt,

  image("images/elliptic_curve.png", width: 100%),

  text(fill: black)[
    *Group addition:* draw line through $P, Q$, mirror third intersection point → $R = P + Q$.

    *Doubling:* $R = 2P$: use tangent at $P$. No intersection → point at $infinity$.

    Inverse of $P$: mirror at $x$-axis.

    *Scalar multiplication:* $k dot P$ = adding $P$ to itself $k$ times; computed efficiently via double-and-add.
  ],
)
*ECDLP:* given points $P$ and $G$, find scalar $k$ s.t. $P=k G$. Believed hard for specific curves over finite fields.\
*Key size advantage:* 128-bit security → 256-bit EC key vs 3072-bit RSA key. Smaller keys = faster computation and less bandwidth.

=== ECDH Key Exchange
Alice picks random $a$, sends $A=a G$. Bob picks random $b$, sends $B=b G$. Both over authentic channel.\
Shared secret: $a b G = a B = b A$. Attacker sees only $A$ and $B$ — cannot recover $a b G$ without solving ECDLP.\
Use $H(a b G)$ as actual key since $a b G$ is a curve point, not a uniform bitstring.\
*Security chain:* DLP $>=$ CDH $>=$ DDH in hardness. 
#table(
  columns: (1fr, 1fr),
  stroke: none,
  inset: 0pt,

  text(fill: black)[
    *Breaking DLP breaks CDH and DDH.*

    If CDH holds, attacker cannot learn the full shared secret.

    If DDH holds, the shared secret is indistinguishable from random.
  ],

  image("images/ec_dh.png", width: 100%),
)
== Signatures
Authentic channels need signatures; signatures need no prior shared secret — breaks the chicken-and-egg problem.\
*PKI:* binds public keys to identities via X.509 certificates issued by Certificate Authorities. Bob verifies Alice's public key via CA signature.\
*Hash-then-sign:* hash message first → fixed, predictable work regardless of message size.\
*Properties:* _Correctness_ #hinweis[(valid sigs always verify)], _Integrity_ #hinweis[(any alteration invalidates)], _Unforgeability_ #hinweis[(infeasible to fake)], _Authenticity_ #hinweis[(confirms sender)], _Non-repudiation_ #hinweis[(signer can't deny)].\
*EUF-CMA:* hard to forge even after seeing many signatures. Vulnerable to transaction malleability — valid signature for a different-but-related message.\
*SUF-CMA:* closes transaction malleability gap — no valid alternative signature exists.

=== ECDSA
Public params: curve $C(F)$, base point $G$, prime $n$ = group order. Private key: random $d in ZZ_n$. Public key: $P=d G$.\
*Sign:* $h=H(m)$ as integer in $ZZ_n$; random $k$; $(x,y)=k G$; $r=x mod n$; $s=(h+r d) dot k^(-1) mod n$. Signature: $(r,s)$.\
*Verify:* $u=h s^(-1) mod n$, $v=r s^(-1) mod n$; compute $(x',y')=u G+v P$; check $x' equiv r$.

=== Ed25519
No random nonce needed → no nonce reuse risk. Faster than ECDSA. Same public params style as ECDSA.\
*Keygen:* private key = random bitstring $k$ #hinweis[(usually 256 bit)]. Derive $a || h = "SHA-512"(k)$. Public key: $P=a G$, use $h$ for signing.\
*Sign:* $r=H(h || m)$, $R=r G$, $S=r+H(R || P || m) dot a mod n$. Signature: $(R,S)$.\
*Verify:* compute $H(R || P || m)$; check $S G = R + H(R || P || m) dot P$.

= Post-Quantum Cryptography
Quantum computers use _qubits_ #hinweis[(multiple states beyond 0/1, reversible gates)] — fundamentally different from classical computing. Shor's algorithm solves factoring and discrete log efficiently → breaks RSA, ECDSA, DH. Must prepare before quantum computers are widespread.\
*Grover's algorithm:* speeds up brute-force search from $O(n)$ to $O(sqrt(n))$ — not fast enough to break symmetric crypto, just double key size #hinweis[(AES-128 → AES-256)].\
*Shor's algorithm:* factors 2048-bit RSA modulus with only 2000–4000 qubits. Breaks all asymmetric schemes based on factoring or discrete log.\
*Affected:* asymmetric encryption, key exchange, signing. Symmetric + hash functions remain safe with larger keys.

== PQC Approaches
_Lattices_: Shortest Vector Problem in high-dimensional lattices is hard — basis for KEM, signatures, encryption.\
_Code-based_: error-correcting codes, NP-hard.\
_Isogenies_: maps between elliptic curves, random walks on curve graph — proven vulnerable.\
_Multivariate_: hard polynomial equations #hinweis[(e.g. Unbalanced Oil and Vinegar signatures)].\
_Hash-based_: built on quantum-secure hash functions like SHA-2.

*NIST approved schemes:*
#table(columns: (1fr, 1fr, 1fr),
  [*Purpose*], [*Scheme*], [*Basis*],
  [Signing], [Dilithium], [Lattice],
  [Signing], [Falcon], [Lattice],
  [Signing], [SPHINCS+], [Hash],
  [KEM], [Kyber], [Lattice],
)
PQC schemes are less tested, some broken already, and generally require more key space and computation.

== PQC Migration
*1. Inventory:* catalogue all crypto in your system — protocols, libraries, keys/certificates, secrets. Connect to policy questions #hinweis[(acceptable TLS cipher suites? key protection requirements? approved libraries?)]. Keep inventory + policy versioned and updated regularly. Ensure supply chain partners are also PQC-ready. Enables _cryptographic agility_ — easy scheme replacement when something breaks.\
*2. Priorities:* assess harvest-now-decrypt-later attacks — attacker stores encrypted data today, decrypts once quantum computer available. Rank impact of each vulnerable scheme as High/Medium/Low #hinweis[(data loss, impersonation, etc.)] similar to standard threat modelling.\
*3. Migration:* stay agile — build plan, execute, periodically reevaluate. Imperfect execution beats inaction. Replace components in-place or migrate service to new platform, then retire old.

= Algebraic Structures

#table(columns: (auto, 1fr, 1fr, 1fr),
  [*Structure*], [*Operations*], [*Key Property*], [*Examples*],
  [Group], [one $(*)$], [assoc., identity, inverses], [$ZZ_n,+$  $ZZ_n^*,dot$],
  [Ring], [two $(+,*)$], [group under $+$, monoid under $*$], [$ZZ_n,+,dot$  $ZZ[x]$],
  [Field], [two $(+,*)$], [ring + mult. inverse for all $eq.not 0$], [$ZZ_p, QQ, RR, G F(2^8)$],
)

== Groups
$(G,*)$ valid iff: _Associativity_ $(a*b)*c=a*(b*c)$, _Neutral element_ $a*e=a$, _Inverse_ $a * hat(a)=e$.\
*Group order* $"ord"(G)$: size of $G$, e.g. $"ord"(ZZ_m)=m$.\
*Element order* $"ord"(a)$: smallest $k$ s.t. $a^k=e$.\
*Generator* $g$: $"ord"(g)="ord"(G)$ — every element $a in G$ can be written as $g^k$.\
#hinweis[Example: $G=ZZ_(15)^*$, $"ord"(G)=phi(15)=8$. $"ord"(4)=2$ since $4 dot 4=1$]

== Rings
$(R,+,*)$: $(R,+)$ is abelian group, $(R,*)$ is monoid #hinweis[(assoc. + neutral element, no inverses needed)], distributive law holds. Division not always possible.\
#hinweis[Examples: $(ZZ_n,+,dot)$, $(ZZ,+,dot)$, $ZZ[x]$]

== Fields
Commutative ring where every non-zero element has a multiplicative inverse → $(FF without {0}, *)$ is itself a group. Division always possible (except by 0).\
#hinweis[Examples: $(QQ,+,dot)$, $(RR,+,dot)$, $(CC,+,dot)$]\
*Finite fields:* only two types: $G F(p)=ZZ_p=FF_p$ for prime $p$, or $G F(p^k)$ for prime $p$ and integer $k$.\
*Why prime $p$?* Composite $n=p dot q$ → $p dot q = 0 mod(n)$ (zero divisors) → no mult. inverse for all elements → not a field.

== Extension Fields
Build larger field containing $FF$ as subset. Classic: $CC$ extends $RR$ by defining $i$ s.t. $i^2+1=0$ → $CC={a+b i mid a,b in RR}$. For finite fields: $G F(p^k)$ extends $ZZ_p$.

== Polynomial Rings
$FF[x]$: all polynomials over $FF$ — forms a ring.\
*Addition:* component-wise mod $p$ #hinweis[(XOR for $ZZ_2$)]. *Multiplication:* standard poly mult., reduce coefficients mod $p$.\
#hinweis[$ZZ_2$: $(x^2+x+1)(x^2+1)=x^4+x^3+2x^2+x+1=x^4+x^3+x+1$ since $2=0$]\
*Modulo $m(x)$:* $FF[x]\/m(x)$ — polynomials of degree $< deg(m)$; multiply then reduce mod $m(x)$.\
*Irreducible $m(x)$:* cannot be factored → $FF[x]\/m(x)$ becomes a *field*, not just a ring.\
*AES field:* $G F(2^8)=ZZ_2[x]\/m(x)$, $m(x)=x^8+x^4+x^3+x+1$ — elements are bytes, mult. is mod this polynomial.