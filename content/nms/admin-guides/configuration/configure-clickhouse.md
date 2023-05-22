---
title: "Configure ClickHouse"
date: 2022-03-11T15:09:35Z
draft: false
description: ""
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
docs: "DOCS-998"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management","security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
aliases:
- /nginx-management-suite/admin-guides/configuration/prerequisites/configure-clickhouse/
---

{{<custom-styles>}}

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
      
      # set the log level
      log_level: debug

      address: 127.0.0.1:9001

      # Edit your username
      username: test-1

      # Edit your password
      password: test-2

      debug_mode: true

      # tls_mode will be deprecated. Use tls section below.
      tls_mode: true

      # Enable tls to run clickhouse in TLS mode
      tls:
        # set the IP address and port Clickhouse listens on
        address: 127.0.0.1:9441

        skip_verify: false

        # set the path to TLS private cert
        cert_path: /etc/certs

        # set the path to TLS private key
        key_path: /etc/key

        # set the path to certificate authority for certificate validation
        cert_ca: /etc/ca
      
      migrations_path: /test/migrations
    ```

3. Save the changes and close the file.
