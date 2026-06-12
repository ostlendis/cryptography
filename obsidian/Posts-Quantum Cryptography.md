Posts-Quantum cryptography is about secure cryptography even if quantum computers exist and we assume that an attacker has such a quantum computer.
It is important to prepare cryptographic schemes to be resilient against quantum computers before they are widespread.

Schor's algorithm proves that certain hard problems can be solved exponentially faster by quantum computers, breaking some traditional cryptographic schemes

Quantum computers are build different than traditional computers in a sense that they work on qubits that can have multiple states in addition to 1 and 0 and it uses different gates that can transform qubits. Quantum computing is reversible where traditional computing is not
## Grover's Algorithm
Traditional search problems like searching the key for a given message and ciphertext can only be solved by brute force with an average of n/2 steps for keylength S. Grover's algorithm solves the problem in $O(\sqrt n)$ on a quantum computer. While this is much faster than brute force, it is still not fast enough to consider symmetric cryptographic schemes as broken. We can just double the key size: AES-128 -> AES-256
## Shor's Algorithm
Shors algorithm enables factoring or computing discrete logarithms efficiently. For example you need 2000-4000 qbits to factor a 2048-bit RSA modulus.
## Goal of PQC
Post-Quantum cryptography fixes the problems that arise from quantum computers, namely asymmetric encryption like RSA, ECDSA and DH. Encryption, key exchange and signing is affected.
### Lattices
The Shortest Vector Problem in high dimensional lattices is considered hard. Here, we are trying to find the shortest vector in a lattice that is non-zero.

There are multiple implementations based on this problem for key exchange, signatures and encryption
### Code Based
There are cryptographic schemes based on error correcting codes that are NP-hard
### Isogenies
Isogeny is a map between two elliptic curves. You can combine them to make a graph on which you can do random walks for key exchange. It is proven to be vulnerable tough.
### Multi-variate
This is cryptography based on polynomial equations such as Unbalanced Oil
and Vinegar signatures. Solving these equations is hard.
### Hash based
You can also build cryptographic schemes based on hash functions such as SHA-2 which are qantum secure.
### NIST approved
- Signing
	- Lattice-based
		- dilithium
		- falcon
	- hash-based
		- shpincs+
- key exchange
	- lattice based
		- kyber
	- hash-based
		- not yet named
PQC schemes are less tested and some even got broken. Additionally, they take more key space and are slower to compute.
## PQC migration
To migrate to PQC, you take 3 steps: Inventory, Priorities, Migration.
### Inventory
Create an overview of all cryptography used in a system, including:
- protocols
- libraries
- keys/certificates
- secrets
- ...
The inventroy must be connected to policy questions like
- what cipher suites are acceptable for TLS connections?
- how must signing keys be protected?
- which libraries are acceptable?
Policy and inventory are not static and must be updated regularly, best with versioning. It enables cryptographic agility allowing you to easily replace schemes if it becomes broken.
Make sure your partners in your supply chain do the same and are ready for PQC migration.
### Priorities
