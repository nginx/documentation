---
title: Post-installation options for NGINX Instance Manager
linkTitle: Post-installation options
toc: true
weight: 50
type: how-to
product: NIM
nd-docs:
---

After installing NGINX Instance Manager, you can optionally configure additional components and settings for security, metrics, or integration with external services.

## Configure SELinux

SELinux helps secure your deployment by enforcing mandatory access control policies.  

If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore default contexts (`restorecon`) for files and directories used by NGINX Instance Manager.

## Configure Vault

NGINX Instance Manager can use [Vault](https://www.vaultproject.io/) to store secrets such as passwords.  

To set up Vault integration, follow the [Vault configuration steps]({{< ref "/nim/system-configuration/configure-vault.md" >}}).

## Configure ClickHouse

If you installed ClickHouse and set a password (the default is blank), you must update the `clickhouse.password` setting in the `/etc/nms/nms.conf` file. Without the correct password, NGINX Instance Manager will not start.

You can also configure other connection settings, such as the ClickHouse address, username, or TLS options.

For full details, see [Configure ClickHouse]({{< ref "nim/system-configuration/configure-clickhouse.md" >}}).

## Disable metrics collection

If you did not install ClickHouse or do not plan to use it, disable metrics collection in the `/etc/nms/nms.conf` and `/etc/nms/nms-sm-conf.yaml` files.  

See [Disable metrics collection]({{< ref "nim/system-configuration/configure-clickhouse.md#disable-metrics-collection" >}}) for instructions.

## Update the CVE list (for offline deployments)

In offline environments, you must manually download and apply the latest CVE list to keep security advisories up to date.  

For instructions, see [Update CVE list (offline)]({{< ref "/nim/system-configuration/update-cve-list-offline.md" >}}).