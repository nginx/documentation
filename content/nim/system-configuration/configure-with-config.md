---
description: ''
docs: DOCS-1100
title: Configure NGINX Instance Manager with nms.conf
toc: true
weight: 1
type:
- how-to
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

## Overview

This guide explains how to configure F5 NGINX Instance Manager by editing the **/etc/nms/nms.conf** file.

## Before you start

Before you set up NGINX Instance Manager, ensure:

- You have access to the **/etc/nms/nms.conf** file on the host where NGINX Instance Manager is installed.
- You understand the required settings and options.
- You have the necessary permissions to edit the configuration file.

## Configuration details

Edit the **/etc/nms/nms.conf** file to configure NGINX Instance Manager. The comments in the example configuration file provide details on each setting and its usage.

### Example nms.conf with default settings and values

```yaml
# This is the default /etc/nms/nms.conf file distributed with Linux packages.

user: nms
daemon: true
# Root dqlite db directory. Each subdirectory here is dedicated to the process
db_root_dir: /var/lib/nms/dqlite

# Default log level for all processes. Each process can override this level.
log:
  encoding: console
  level: error

modules:
  prefix: /var/lib/nms
  # NMS modules config are available here to be read if installed
  conf_dir: /etc/nms/modules

core:
  # Enable this for core on TCP
  # address: 127.0.0.1:8033
  address: unix:/var/run/nms/core.sock
  grpc_addr: unix:/var/run/nms/coregrpc.sock
  analytics:
    # Catalogs config
    catalogs:
      metrics_data_dir: /usr/share/nms/catalogs/metrics
      events_data_dir: /usr/share/nms/catalogs/events
      dimensions_data_dir: /usr/share/nms/catalogs/dimensions
  # Dqlite config
  dqlite:
    addr: 127.0.0.1:7891
  # Disable this to prevent automatic cleanup on a module removal of its RBAC features and permissions
  disable_rbac_cleanup: false

dpm:
  # Enable this for dpm on TCP
  # address: 127.0.0.1:8034
  address: unix:/var/run/nms/dpm.sock
  # Enable this for dpm gRPC server on TCP
  # grpc_addr: 127.0.0.1:8036
  grpc_addr: unix:/var/run/nms/am.sock
  # Dqlite config
  dqlite:
    addr: 127.0.0.1:7890
  # WATCHDOG configurations
  # Enable this setting to specify how often, in seconds, messages are sent to the watchdog.
  # The default interval is 2 seconds
  reporting_period: 2s
  # Enable this setting to specify how often, in seconds, the system checks in with the watchdog timer to reset.
  # The default interval is 5 seconds
  check_period: 5s
  # Enable this setting to specify the maximum allowable time for the system to operate without resetting the watchdog.
  # The default interval is 30 seconds
  threshold_duration: 30s
  # Enable this setting to specify how often, in seconds, performance statistics are collected and analyzed by the watchdog.
  # The default interval is 30 seconds
  stats_period: 30s
  # Enable this setting to specify the maximum amount of time allowed for a deployment process to complete.
  # The default interval is 10 minutes
  deployment_timeout: 10m
  # NATS config
  nats:
    address: nats://127.0.0.1:9100
    # NATS streaming
    store_root_dir: /var/lib/nms/streaming
    # 10GB
    max_store_bytes: 10737418240
    # 1GB
    max_memory_bytes: 1073741824
    # https://docs.nats.io/reference/faq#is-there-a-message-size-limitation-in-nats
    # 8MB
    max_message_bytes: 8388608
  # ClickHouse schema migration check interval
  clickhouse_migration_interval: 100s
  # Enable this setting to specify how often, in hours, offline agents are pruned from the system
  # The default interval is 72 hours
  agent_prune_duration: 72h
  # Enable this setting to specify how often, in hours, offline container agents are pruned from the system
  # The default interval is 12 hours
  agent_container_prune_duration: 12h

integrations:
  # Enable this for integrations on TCP
  # address: 127.0.0.1:8037
  address: unix:/var/run/nms/integrations.sock
  # Dqlite config
  dqlite:
    addr: 127.0.0.1:7892
  app_protect_security_update:
    # Enable this setting to automatically retrieve the latest Attack Signatures and Threat Campaigns.
    enable: true
    # Enable this setting to specify how often, in hours, the latest Attack Signatures and Threat Campaigns are retrieved.
    # The default interval is 6 hours, the maximum interval is 48 hours, and the minimum is 1 hour.
    interval: 6
    # Enable this setting to specify how many updates to download for the latest Attack Signatures and Threat Campaigns.
    # By default, the 10 latest updates are downloaded. The maximum value is 20, and the minimum value is 1.
    number_of_updates: 10
  policy_manager:
    # Time to live for attack signatures. If the attack signatures exceed their TTL and are not deployed to an instance or
    # instance group, they will be deleted from the database. Duration unit can be seconds (s), minutes (m), or hours (h).
    attack_signatures_ttl: 336h
    # Time to live for compiled bundles, this includes compiled security policies and compiled log profiles. If a compiled
    # bundle exceeds its TTL and is not deployed to an instance or instance group, it will be deleted from the database. Note
    # that the compiled bundle is deleted, not the definition of it (that is, the security policy or log profile definition).
    # Duration unit can be seconds (s), minutes (m), or hours (h).
    compiled_bundles_ttl: 336h
    # Time to live for threat campaigns. If the threat campaigns exceed their TTL and are not deployed to an instance or
    # instance group, they will be deleted from the database. Duration unit can be seconds (s), minutes (m), or hours (h).
    threat_campaigns_ttl: 1440h
  license:
    db:
      addr: 127.0.0.1:7893

ingestion:
  # Enable this for ingestion gRPC server on TCP
  # grpc_addr: 127.0.0.1:8035
  grpc_addr: unix:/var/run/nms/ingestion.sock
  # Parameters for ingesting metrics and events
  sink:
    # All limits are inclusive on both ends of the bound.
    # Buffer_size limits: 2,000 - 1,000,000
    buffer_size: 20000
    buffer_flush_interval: 1m
    buffer_check_interval: 1s
    # Insert_connection_retries limits: -1 - 10
    insert_connection_retries: -1
    insert_connection_retry_interval: 5s
    # Insert_timeout_retries limits: 2 - 10
    insert_timeout_retries: 3
    insert_timeout_retry_interval: 30s
    transaction_timeout: 30s
    # Concurrent_transactions limits: 2 - 20
    concurrent_transactions: 10

# ClickHouse config for establishing a ClickHouse connection
clickhouse:
  # Below address not used if TLS mode is enabled
  address: 127.0.0.1:9000
  # Ensure username and password are wrapped in quotes
  # The default ClickHouse username on install is empty. If you've set up a custom user, set the username here
  username: ""
  # The default ClickHouse password on install is empty. If you've set a custom password, set the password here
  password: ""
  # The TTL configurations below define how long data for features will be retained in ClickHouse
  # The default values can be updated for a custom retention period. Restart nms-dpm to apply any modifications to TTL
  ttl_configs:
    - feature: metrics
      ttl: 32 # number of days
    - feature: events
      ttl: 120 # number of days
    - feature: securityevents
      ttl: 32 # number of days
#   # Enable TLS configurations for ClickHouse connections
#   tls:
#     # Address pointing to <tcp_port_secure> of ClickHouse
#     # Below CH address is used when TLS mode is active
#     tls_address: 127.0.0.1:9440
#     # Verification should be skipped for self-signed certificates
#     skip_verify: true
#     key_path
```
