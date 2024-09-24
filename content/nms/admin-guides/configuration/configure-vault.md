---
description: Follow the steps in this guide to configure F5 NGINX Management Suite to
  use HashiCorp's Vault for storing secrets.
docs: DOCS-999
doctypes:
- tutorial
tags:
- docs
title: Configure Vault for Storing Secrets
toc: true
weight: 200
---

{{< shortversions "2.6.0" "latest" "nimvers" >}}

HashiCorp's Vault is a popular solution for storing secrets. While F5 NGINX Management Suite provides encryption-at-rest for secrets stored on disk, if you have an existing Vault installation, you may prefer to store all secrets in one place. NGINX Management Suite provides a driver you can use to connect to existing Vault installations and store secrets.

## Before You Begin

To complete the steps in this guide, you need the following:

- A working understanding of [Vault](https://www.vaultproject.io) and its operations
- A running version of [Vault 1.8.8 or later](https://www.vaultproject.io/docs/install)

---

## Create Periodic Service Tokens {#create-periodic-service-tokens}

Access to a vault requires a renewable token.

{{<note>}}If you attempt to use the vault's Root Token, NGINX Management Suite will not be able to start the secrets driver, as that token is not renewable.{{</note>}}

To create a periodic service token for NGINX Management Suite, take the following steps:

1. Use the Vault user interface to create a new policy.

   The "default" policy has no access to store or retrieve secrets, and the root policy is too broad. We recommend creating a policy called `nms_secrets` with these capabilities:

    ```text
    path "secret/*" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
    ```

2. Create an initial service token that will last so long as it's renewed on time until it's manually revoked. We recommend a period of 24 hours, which is used in the following example. NGINX Management Suite will always attempt to renew tokens before expiring, so shorter times also work.

   To create a token, take the following step, substituting your vault's Root Token for `$VAULT_ROOT_TOKEN` and your vault's address for `$VAULT_ADDR`:

    ```bash
    curl -X POST --header "X-Vault-Token: $VAULT_ROOT_TOKEN" \
      --data '{"policies": "nms_secrets", "period": "24h"}' \
      $VAULT_ADDR/v1/auth/token/create | jq -r ".auth.client_token" > periodic_token.txt
    ```

3. Verify your token works:

    ```bash
    curl --header "X-Vault-Token: $(cat periodic_token.txt)" \
      $VAULT_ADDR/v1/auth/token/lookup-self | jq .data
    ```

4. If everything looks good, stop the `nms-core` service and configure NGINX Management Suite to use your token:

    ```bash
    sudo systemctl stop nms-core
    sudo NMS_VAULT_TOKEN=$(cat periodic_token.txt) nms-core secret vault-token
    sudo systemctl restart nms-core
    ```

---

## Start Using Vault to Store Secrets {#start-using-vault}

1. To use the new token on the NGINX Management Suite server, open the `/etc/nms/nms.conf` file for editing.

2. Update the `secrets` section indented under `core` to tell NGINX Management Suite how to handle secrets.

   For example, an internal development installation of Vault might use:

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
4. Restart the NGINX Management Suite services to start using Vault to store secrets:

   ```bash
   sudo systemctl restart nms
   ```

---

## Switching between Vault and Local Encryption  {#switch-to-from-vault}

After you've set up Vault to store your secrets, you can easily switch between local encryption and Vault as desired.

### Switch to Local Encryption

To switch from using Vault to local disk encryption, take the following steps:

1. Stop NGINX Management Suite to ensure exclusive access to the secrets:

   ```bash
   sudo systemctl stop nms
   ```

2. Run the following command to migrate secrets from Vault to your local disk:

   ```bash
   sudo nms-core secret migrate-secrets-to-local
   ```

3. Update the `core/secrets/driver` line from `/etc/nms/nms.conf`, which you added in the previous section, to say `driver: local`.

4. Restart NGINX Management Suite:

   ```bash
   sudo systemctl start nms
   ```

### Switch to Vault

To switch from using local encryption back to Vault, take the following steps:

1. Stop NGINX Management Suite to ensure exclusive access to the secrets:

   ```bash
   sudo systemctl stop nms
   ```

2. Run the following command to migrate secrets from your local disk to Vault:

   ```bash
   sudo nms-core secret migrate-secrets-to-vault
   ```

3. Update the `core/secrets/driver` line from `/etc/nms/nms.conf`, which you added in the previous section, to say `driver: vault`.

4. Restart NGINX Management Suite:

   ```bash
   sudo systemctl start nms
   ```

---

## Troubleshooting

<details open>
<summary>Token has expired</summary>

If the vault service token is manually revoked or expires before renewal -- possibly because NGINX Management Suite was shut down and was
unavailable to renew the token, all access to stored secrets will fail.

To resolve this problem, you need is to supply a new service token using `nms-core secret vault-token`. See the [Create Periodic Service Tokens](#create-periodic-service-tokens) section above for details on generating and supplying a new token.
</details>

<br>

<details open>
<summary>Certs are missing after switching to/from Vault</summary>

When configuring Vault for storing secrets, NGINX Management Suite assumes that no secrets have been stored previously and won't migrate any existing stored secrets. All existing certs must be uploaded again.

Stored secrets are not deleted: secrets remain in the encrypted disk storage or vault. We can't guarantee that the secrets will remain accessible forever. If you want to recover the missing secrets, you can [switch back to the other method for storing secrets](#switch-to-from-vault) following the instructions above. Then restart NGINX Management Suite to see the old secrets again.
</details>
