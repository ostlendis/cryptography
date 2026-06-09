Advanced Encryption Standard (AES) is a block cipher that uses a Substitution Permutation Network and operates on bytes, instead of bits. The block size is 128 bit.
It consists of several steps each round:
- KeyExpansion - the key is cycled and generates a round-specific key of 128 bit length
- SubBytes - Each byte is changes via a S-box
- ShiftRows - Rows are shifted
- MixColumns - Columns are mixed with Matrix multiplication
- AddRoundKey - Each byte is xor-ed with the derived key
You can imagine the 16 bytes (128 bit) of block data to be arranged in a 4x4 matrix. ShiftRows and MixColumns are all easily reversible and add diffusion
#### SubBytes
On each byte, an S-box is applied. The S-box is the only non-linear part of AES and therefore the only thing that protects against linear attacks.
![[Pasted image 20260609090413.png]]
##### ShiftRows
Each Row is shifted according to its row index: the first row is not shifted, the second by 1 and so on.
![[Pasted image 20260609090505.png]]
##### MixColumns
Each column is multiplied with a matrix such that each input byte changes every output byte.
![[Pasted image 20260609091241.png]]
#### AddRoundKey
In the final step, each byte is xor-ed with the corresponding byte of the key.
![[Pasted image 20260609091344.png]]
#### implementation
AES is implemented with either lookup tables or directly in hardware for more efficiency. Most modern CPUs have specific instructions for AES encryption.