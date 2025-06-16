---
docs: DOCS-999
title: Use Vault for storing secrets
toc: true
weight: 200
type:
- tutorial
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

HashiCorp's Vault is a popular solution for storing secrets. While F5 NGINX Instance Manager provides encryption-at-rest for secrets stored on disk, you may prefer to store all secrets in one place if you have an existing Vault installation. NGINX Instance Manager provides a driver to connect to existing Vault installations and store secrets.

## Before you begin

To complete the steps in this guide, you need:

- A working understanding of [Vault](https://www.vaultproject.io) and its operations.
- A running version of [Vault 1.8.8 or later](https://www.vaultproject.io/docs/install).

---

## Create periodic service tokens {#create-periodic-service-tokens}

Access to a Vault requires a renewable token.

{{<note>}}If you attempt to use the Vault's Root Token, NGINX Instance Manager won't start the secrets driver, as that token is not renewable.{{</note>}}

To create a periodic service token for NGINX Instance Manager:

1. Use the Vault user interface to create a new policy.

   The "default" policy doesn't allow storing or retrieving secrets, and the root policy is too broad. Create a policy called `nms_secrets` with these capabilities:

    ```text
    path "secret/*" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
    ```

2. Create a renewable service token. We recommend a period of 24 hours. NGINX Instance Manager renews tokens automatically, so shorter periods also work. Run the following, replacing `$VAULT_ROOT_TOKEN` with your Vault's Root Token and `$VAULT_ADDR` with your Vault's address:

    ```bash
    curl -X POST --header "X-Vault-Token: $VAULT_ROOT_TOKEN" \
      --data '{"policies": "nms_secrets", "period": "24h"}' \
      $VAULT_ADDR/v1/auth/token/create | jq -r ".auth.client_token" > periodic_token.txt
    ```

3. Verify the token works:

    ```bash
    curl --header "X-Vault-Token: $(cat periodic_token.txt)" \
      $VAULT_ADDR/v1/auth/token/lookup-self | jq .data
    ```

4. If everything works, stop the `nms-core` service and configure NGINX Instance Manager to use the token:

    ```bash
    sudo systemctl stop nms-core
    sudo NMS_VAULT_TOKEN=$(cat periodic_token.txt) nms-core secret vault-token
    sudo systemctl restart nms-core
    ```

---

## Start using Vault to store secrets {#start-using-vault}

1. Open the `/etc/nms/nms.conf` file on the NGINX Instance Manager server.
2. Update the `secrets` section under `core` to specify how to manage secrets.

   For example, an internal Vault installation might use:

   ```text
   secrets:
     # change driver to "local" if you want to stop using vault
     driver: vault
     config:
       # local file path for stored secrets when using the local driver
       path: /var/lib/nms/secrets
       # key_file is required for local driver
       key_file: /var/lib/nms/secrets/key
       # vault address for when using the vault driver
       address: http://127.0.0.1:8200/v1
       # isolation is used to store secrets in a specific namespace and prefix to better restrict access rights
       # on the local file system or shared vault server.
       isolation:
         namespace: secret
         prefix: secureString
   ```

3. Save the changes and close the file.
4. Restart the NGINX Instance Manager services to start using Vault:

   ```bash
   sudo systemctl restart nms
   ```

---

## Switch between Vault and local encryption {#switch-to-from-vault}

After setting up Vault, you can switch between local encryption and Vault.

### Switch to local encryption

1. Stop NGINX Instance Manager:

   ```bash
   sudo systemctl stop nms
   ```

2. Migrate secrets to local storage:

   ```bash
   sudo nms-core secret migrate-secrets-to-local
   ```

3. Update the `core/secrets/driver` in `/etc/nms/nms.conf` to use the local driver:

   ```text
   driver: local
   ```

4. Restart NGINX Instance Manager:

   ```bash
   sudo systemctl start nms
   ```

### Switch to Vault

To switch from using local encryption back to Vault:

1. Stop NGINX Instance Manager:

   ```bash
   sudo systemctl stop nms
   ```

2. Migrate secrets to Vault:

   ```bash
   sudo nms-core secret migrate-secrets-to-vault
   ```

3. Update the `core/secrets/driver` line in `/etc/nms/nms.conf` to use the Vault driver:

   ```text
   driver: vault
   ```

4. Restart NGINX Instance Manager:

   ```bash
   sudo systemctl start nms
   ```

---

## Troubleshooting

### Token has expired

If the Vault service token is revoked or expires, access to stored secrets will fail. To resolve this, generate and supply a new service token using `nms-core secret vault-token`. See [create periodic service tokens](#create-periodic-service-tokens) for details.

### Missing certs after switching

When switching to Vault, NGINX Instance Manager doesn't migrate existing secrets. Reupload missing certs or switch back to the original storage method to recover access. Restart the service to view the restored secrets.
