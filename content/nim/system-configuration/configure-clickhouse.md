---
description: ''
docs: DOCS-998
title: Configure ClickHouse
toc: true
weight: 100
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

Follow this guide to update the `/etc/nms/nms.conf` file if you used a custom address, username, or password, or enabled TLS during ClickHouse installation. NGINX Instance Manager requires this information to connect to ClickHouse.

## Default ClickHouse values {#default-values}

Unless otherwise specified in the `/etc/nms/nms.conf` file, NGINX Instance Manager uses the following default values for ClickHouse:

{{< include "installation/clickhouse-defaults.md" >}}

---

## Use custom address, username, or password

If your ClickHouse installation uses a custom address, username, or password, update the NGINX Instance Manager configuration to match.

To set custom values:

1. Open the `/etc/nms/nms.conf` file on the NGINX Instance Manager server.
2. Update the following settings to match your ClickHouse configuration:

    ```yaml
    clickhouse:
      address: tcp://localhost:9000
      username: <INSERT USERNAME HERE>
      password: <INSERT PASSWORD HERE>
    ```

3. Save and close the file.

---

## Configure TLS

If you enabled TLS for ClickHouse, update the `nms.conf` file settings to enable secure connections.

To configure TLS:

1. Open the `/etc/nms/nms.conf` file on the NGINX Instance Manager server.
2. Update the `clickhouse` TLS settings as needed:

    ```yaml
    clickhouse:

      # Sets the log level for ClickHouse processes within NMS.
      log_level: debug

      # Sets the address that will be used to connect to ClickHouse.
      address: 127.0.0.1:9001

      ## Note: Username and password should only be set, if you have custom defined username and password for ClickHouse.
      ## Ensure that any configured username or password is wrapped in single quotes.
      # Sets the username that will be used to connect to ClickHouse.
      username: 'test-1'

      # Sets the password that will be used to connect to ClickHouse.
      password: 'test-2'

      # Activates or deactivates TLS for connecting to ClickHouse.
      # Note: `tls_mode` will be deprecated in the future, use the `tls` key to enable TLS connection for ClickHouse.
      tls_mode: true

      tls:
        # Sets the address (form <ip-address:port>)used to connect to ClickHouse with a TLS connection.
        address: 127.0.0.1:9441

        # Activates or deactivates TLS verification of ClickHouse connection.
        skip_verify: false

        # Sets the path of the certificate used for TLS connections in PEM encoded format.
        cert_path: /etc/certs

        # Sets the path of the client key used for TLS connections in PEM encoded format.
        key_path: /etc/key

        # Sets the path of the Certificate Authority installed on the system for verifying certificates.
        cert_ca: /etc/ca

      # Sets directory containing ClickHouse migration files.
      migrations_path: /test/migrations
    ```

3. Save and close the file.
