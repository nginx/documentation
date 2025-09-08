---
docs:
files:
- content/nim/deploy/vm-bare-metal/install-nim-manual.md
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/disconnected/offline-install-guide-manual.md
- content/nim/disconnected/offline-install-guide.md
---

NGINX Instance Manager can use [Vault](https://www.vaultproject.io/) as a datastore for secrets.

To install and enable Vault, follow these steps:

- Follow Vault's instructions to [install Vault 1.8.8 or later](https://developer.hashicorp.com/vault/install) for your operating system.
- Ensure you're running Vault in a [production-hardened environment](https://learn.hashicorp.com/tutorials/vault/production-hardening).
- After installing NGINX Instance Manager, follow the steps to [configure Vault for storing secrets]({{< ref "/nim/system-configuration/configure-vault.md" >}}).
