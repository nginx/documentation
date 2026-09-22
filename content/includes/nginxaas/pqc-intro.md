---
f5-product: F5 NGINXaaS
f5-files:
- content/nginxaas/aws/quickstart/pqc.md
- content/nginxaas/google/quickstart/pqc.md
---

Post-quantum cryptography (PQC) protects TLS connections against future quantum computers. A quantum computer powerful enough to break current public-key algorithms like RSA and Elliptic Curve Cryptography (ECC) could decrypt traffic captured today. Security teams call this threat harvest now, decrypt later. F5 ${product} addresses this with two modes:

- **Hybrid mode**: Combines classical elliptic-curve key exchange with the Module-Lattice-Based Key-Encapsulation Mechanism (ML-KEM) for data encryption. This protects against quantum attacks while staying compatible with clients that don't yet support PQC.
- **Full PQC mode**: Uses Module-Lattice-Based Digital Signature Algorithm (ML-DSA) certificates and keys that you provide. This gives you a fully post-quantum TLS stack when both client and server support it.
