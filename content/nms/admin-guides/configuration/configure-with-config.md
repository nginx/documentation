---
description: Follow the steps in this guide to configure NGINX Management Suite with
  a configuration file.
docs: DOCS-1100
doctypes:
- task
tags:
- docs
title: Configure NGINX Management Suite with nms.conf
toc: true
weight: 1
---

## Overview

You can configure NGINX Management Suite using a file, which is located at **/etc/nms/nms.conf** by default.

Examples of settings and options include:

- The certificate authority (CA) file used for TLS
- The URL for NGINX Management Suite
- The root directory for Dqlite data
- If NGINX Management Suite should run in development or daemon mode
- Additional settings related to logging, modules and services

These options can be set for the user and group that non-privileged processes should use.

## Example configuration

This example **nms.conf** file displays the configurable options, including their usage, placement, and default values.

```yaml
# Sets non-privileged processes to run as a specified user.
user: nms

#  Sets non-privileged processes to run as a specified group.
group:

# Sets CA cert file used for TLS server.
ca_file:

# Sets the NGINX Management Suite URL.
fqdn: 127.0.0.1:443

# Run service in development mode.
dev_mode:

# Sets a daemon mode for running binary.
daemon: true

# Sets the root directory for Dqlite data.
db_root_dir: /var/lib/nms/dqlite

# For cloud Usage, the Cloud Services catalog ID for this product.
# Note: `cloud_catalog_id` will be deprecated in the future.
cloud_catalog_id:

# Sets file mode for all unix sockets
socket_file_mode: 0660

log:
  # Sets the log level for all processes.
  level: error

  # Sets logging output encoding [console, json].
  encoding: console

# To configure NGINX Management Suite in High Availability mode, set ha.
ha:
  # With HA, use this flag to set the cluster size.
  cluster_size: 3

modules:
  # Sets full path for the modules prefix, modules and modules.json will be created.
  prefix: /var/lib/nms

  # Sets path for modules config files will be located.
  conf_dir:

# Sets disable context sub-loggers flag.
disable_context_sub_loggers: false

core:
  # Sets the log level for NGINX Management Suite Core service.
  log_level:

  # Sets the address for NGINX Management Suite Core requests.
  address: unix:/var/run/nms/core.sock

  # Sets the address for NGINX Management Suite Core GRPC requests.
  grpc_addr: unix:/var/run/nms/coregrpc.sock

  # Sets the secrets directory path.
  # Note: `secrets_dir` will be deprecated in the future. Use `secrets` key to set up core secrets.
  secrets_dir: /var/lib/nms/secrets/

  dqlite:
    # Sets the address for Core module Dqlite database address.
    addr: 127.0.0.1:7891

    # Sets the path for Core module Dqlite database initialization schema file.
    schema: etc/nms/core/schema.sql

    # Sets the directory for Core module Dqlite database migration files.
    migrations_dir: /etc/nms/core/migrations

    # With ha, sets the join flag for Core module Dqlite database
    join:

    # Sets verbosity level to debug for Core module Dqlite database.
    verbose:

    # Sets the snap instance name for Core module Dqlite database.
    name: core


  server_certs:
    # Sets the path of cert file for Core TLS endpoints.
    cert:

    # Sets the path of key file for Core TLS endpoints.
    key:

  client_certs:
    # Sets the path of client cert file for Core TLS endpoints.
    cert:

    # Sets the path of key file for Core TLS endpoints.
    key:

  analytics:
    # Sets to enable Core to run in multi-tenancy mode.
    # Note: `multi_tenancy_enabled` will be deprecated in the future.
    multi_tenancy_enabled: false

    catalogs:
      # Sets the path to metrics data directory.
      metrics_data_dir: /usr/share/nms/catalogs/metrics

      # Metrics catalog data (YAML) content - overwrites metrics data file content.
      metrics_data:

      # Sets the path to events data directory.
      events_data_dir: /usr/share/nms/catalogs/events

      # Sets the path to dimensions data directory.
      dimensions_data_dir: /usr/share/nms/catalogs/dimensions

      # Dimensions catalog data (YAML) content - overwrites dimensions data file content.
      dimensions_data:

  license:
    # Sets the period for license status monitoring.
    monitoring_period: 24h

    # Sets the period for license event publishing.
    event_publish_period: 10s

  secrets:
    # Sets driver key for Core secrets.
    driver: local

    # Sets config key for Core secrets.
    config:
      key_file: /var/lib/nms/secrets/key
      limit: 16384
      path: /var/secrets
      subpaths:
        - secret
        - secret/secureString

  # Sets disabling for automatic RBAC cleanup.
  disable_rbac_cleanup:

dpm:

   # Sets the log level for the NGINX Management Suite Data Plane Manager (DPM) service.
  log_level:

  # Sets the address for NGINX Management Suite DPM requests.
  address: unix:/var/run/nms/dpm.sock

  # Sets the address for NGINX Management Suite DPM GRPC requests.
  grpc_addr: unix:/var/run/nms/am.sock

  # If enabled, keeps DPM deployments in list indefinitely.
  deployment_debug: false

  # Sets the timeout (in seconds) of the system entry, after which system will be reported as offline.
  system_timeout: 60

  # Sets the timeout (in seconds) of the nginx entry, after which nginx will be reported as offline.
  nginx_timeout: 60

  # If enabled, validates dpm configuration before config is published.
  validate_before_publish: false

  # If enabled, uses the local copy of the NGINX CVE XML file located at /usr/share/nms/cve.xml.
  offline_nginx_cve: false

  dqlite:
    # Sets the address for DPM module Dqlite database address.
    addr: 127.0.0.1:7890

    # Sets the path for DPM module Dqlite database initialization schema file.
    schema: etc/nms/dpm/schema.sql

    # Sets the directory for DPM module Dqlite database migration files.
    migrations_dir: /etc/nms/dpm/migrations

    # With ha, sets the join flag for DPM module Dqlite database
    join:

    # Sets verbosity level to debug for DPM module Dqlite database.
    verbose:

    # Sets the snap instance name for DPM module Dqlite database.
    name: dpm

  server_certs:
    # Sets the path of cert file for DPM TLS endpoints.
    cert:

    # Sets the path of key file for DPM TLS endpoints.
    key:

  client_certs:
    # Sets the path of client cert file for DPM TLS endpoints.
    cert:

    # Sets the path of key file for DPM TLS endpoints.
    key:

  nats:
    # Sets the NATS service address.
    address: nats://127.0.0.1:9100

    # With ha, sets the NATS service proxy address
    proxy_address:

    # Sets the NATS streaming store root directory.
    store_root_dir: /var/lib/nms/streaming

    # Sets the NATS streaming maximum store in bytes.
    max_store_bytes: 10737418240

    # Sets the NATS streaming maximum memory in bytes.
    max_memory_bytes: 1073741824

    # Sets the NATS streaming maximum message in bytes.
    max_message_bytes: 1048576

integrations:
  # Sets the log level for Integrations.
  log_level:

  # Sets the http server listen address for Integrations.
  address: unix:/var/run/nms/integrations.sock"


  dqlite:
    # Sets the address for Integrations module Dqlite database address.
    addr: 127.0.0.1:7892

    # Sets the path for Integrations module Dqlite database initialization schema file.
    schema: etc/nms/integrations/schema.sql

    # Sets the directory for Integrations module Dqlite database migration files.
    migrations_dir: /etc/nms/integrations/migrations

    # With ha, sets the join flag for Integrations module Dqlite database.
    join:

    # Sets verbosity level to debug for Integrations module Dqlite database.
    verbose:

    # Sets the snap instance name for Integrations module Dqlite database.
    name: integrations

  server_certs:
    # Sets the path of cert file for Integrations TLS endpoints.
    cert:

    # Sets the path of key file for Integrations TLS endpoints.
    key:

  client_certs:
    # Sets the path of client cert file for Integrations TLS endpoints.
    cert:

    # Sets the path of key file for Integrations TLS endpoints.
    key:


ingestion:

  # Sets the log level for Ingestion.
  log_level:

  # Sets the GRPC server listen address for agent Ingestion.
  grpc_addr: unix:/var/run/nms/ingestion_test.sock

  server_certs:
    # Sets the path of cert file for Ingestion TLS endpoints.
    cert:

    # Sets the path of key file for Ingestion TLS endpoints.
    key:

clickhouse:

  # Sets the log level for ClickHouse.
  log_level:

  # Sets the address that will be used to connect to ClickHouse.
  address: tcp://127.0.0.1:9000


  # Note: Username and password should only be set, if you have custom defined username and password for ClickHouse.
  # Sets the username that will be used to connect to ClickHouse.
  username:

  # Sets the password that will be used to connect to ClickHouse.
  password:

  # Activates or deactivates TLS for connecting to ClickHouse.
  # Note: `tls_mode` will be deprecated in the future, use `tls` key to enable TLS connection for ClickHouse.
  tls_mode: true

  tls:
    # Sets the address (form <ip-address:port>)used to connect to ClickHouse with a TLS connection.
    address: tcp://127.0.0.1:9440

    # Activates or deactivates TLS verification of ClickHouse connection.
    skip_verify: false

    # Sets the path of the certificate used for TLS connections in PEM encoded format.
    cert_path:

    # Sets the path of the client key used for TLS connections in PEM encoded format.
    key_path:

    # Sets the path of the Certificate Authority installed on the system for verifying certificates.
    cert_ca: /etc/ssl/certs/ca-certificates.crt

  # Sets directory containing ClickHouse migration files.
  migrations_path: /usr/share/nms/clickhouse/migrations

```

</details>
