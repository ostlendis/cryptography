Cryptography relies on good randomness to generate secrets, nonces and initialization vectors. Cryptography without unpredictability is impossbile.

Good randomness is defined as uniform distribution of events, also known as low entropy. Shanon entropy defines the surprise factor of a distribution. The less entropy, the better.

Generating good randomness on a pc is difficult since the source of entropy such as user inputs are statistically non-uniform.

This is why Pseudo Random Number Generators (PRNG) exist, since as the name suggests they produce randomness that is indistinguishable from true randomness.