Cryptography relies on good randomness to generate secrets, nonces and initialisation vectors. Cryptography without unpredictability is impossible.

Good randomness is defined as uniform distribution of events, also known as low entropy. Shannon entropy defines the surprise factor of a distribution. The less entropy, the better.

# randomness generation
Generating good randomness on a PC is difficult since the source of entropy such as user inputs are statistically non-uniform and true randomness such as temperature, user activity or lava lamps are very slow.

This is why [[Pseudo Random Number Generators]] (PRNG) exist, as they are able to produce randomness very fast but wile being indistinguishable from true randomness. PRNG's generate this randomness from a random seed such that the same seed always produces the same random output.

[[Pseudo Random Function Family]] (PRF) generate a random looking output from a key and input such that for the same key and input, the output is deterministic. 