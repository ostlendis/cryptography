Exchanging keys is no trivial task. Sending over a insecure channel enables man in the middle attacks. We need an authentic channel first to exchange keys so we can verify they come from the person we expect. But authentic channels with [[Symmetric cryptography#Message Authentication|message authentication]] requires keys? This is solved using signatures.
![[Pasted image 20260611161321.png|610]]
# Key Exchange Protocol
KEy Exchange Protocol (KEX) enables exchanging keys by both parties contributing to the key.
# Key Encapsulation Mechanism
Key Encapsulation Mechanism (KEM) enables exchanging keys by one party generating the key and encrypted and sent to the other party.