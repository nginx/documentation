NGINX Management Suite can use [Vault](https://www.vaultproject.io/) as a datastore for secrets.

To install and enable Vault, take the following steps:

- Follow Vault's instructions to [install Vault 1.8.8 or later](https://www.vaultproject.io/docs/install) for your distribution.
- Ensure you are running Vault in a [Production Hardened Environment](https://learn.hashicorp.com/tutorials/vault/production-hardening).
- After [installing NGINX Management Suite](#install-nms-modules), follow the steps to [Configure Vault for Storing Secrets]({{< relref "/nms/admin-guides/getting-started/configure-vault.md" >}}).
