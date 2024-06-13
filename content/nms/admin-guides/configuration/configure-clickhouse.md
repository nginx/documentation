---
description: ''
docs: DOCS-998
doctypes:
- task
tags:
- docs
title: Configure ClickHouse
toc: true
weight: 100
---

## Overview

Follow the steps in this guide to update the `/etc/nms/nms.conf` file if you used a custom address, username, or password or enabled TLS when installing ClickHouse. NGINX Management Suite requires this information to connect to ClickHouse.

## Default ClickHouse Values {#default-values}

Unless specified differently in the `/etc/nms/nms.conf` file, NGINX Management Suite uses the following values for ClickHouse by default:

{{< include "installation/clickhouse-defaults.md" >}}

---

## Use Custom Address, Username, Password

If your ClickHouse installation has a different address, username, or password than the default values, you need to configure NGINX Management Suite to connect to ClickHouse.

To set custom values for the ClickHouse address, username, and password:

1. On the NGINX Management Suite server, open the `/etc/nms/nms.conf` file for editing.
2. Change the following settings to match your ClickHouse configuration:

    ``` yaml
    clickhouse:
      address: tcp://localhost:9000
      username: <INSERT USERNAME HERE>
      password: <INSERT PASSWORD HERE>
    ```

3. Save the changes and close the file.

---

## Configure TLS

If you configured ClickHouse to work with TLS, take the following steps to update the settings in the NGINX Management Suite `nms.conf` file:

1. On the NGINX Management Suite server, open the `/etc/nms/nms.conf` file for editing.
2. Configure the `clickhouse` TSL settings to suit your environment:

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

3. Save the changes and close the file.
