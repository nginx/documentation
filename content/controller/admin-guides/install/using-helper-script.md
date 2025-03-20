---
description: Learn how to update F5 NGINX Controller installation settings and manage
  the NGINX Controller service using the helper.sh script.
docs: DOCS-261
title: Update NGINX Controller Settings with helper.sh
toc: true
weight: 200
type:
- how-to
---

## Overview

You can use the F5 NGINX Controller `helper.sh` script to update NGINX Controller installation settings and manage the NGINX Controller process. This tutorial shows you how to use `helper.sh` to perform the following tasks:

- Install the NGINX Controller prerequisites
- View the version of NGINX Controller that's installed and running
- Start, stop, and restart NGINX Controller
- Back up and restore the NGINX Controller config and encryption keys
- Restore the embedded config database
- Get the NGINX Plus repository key and certificate files (deprecated for `helper.sh` in NGINX Controller v3.9)
- Update the SMTP settings
- Update the database settings
- Update or replace the TLS certificates
- Print the NGINX Controller logs
- Create a support package

## Install NGINX Controller Prerequisites



{{< include "controller/helper-script-prereqs.md" >}}



&nbsp;

---

## View the Installed NGINX Version

To see which version of NGINX Controller is installed and running, type the following command:

``` bash
/opt/nginx-controller/helper.sh version
```

The output looks similar to the following:

``` bash
Installed version: 3.14.0
Running version: 3.14.0
```

&nbsp;

---

## Start, Stop, and Restart NGINX Controller


You can use the `helper.sh` script to start, stop, restart, and check the status of the NGINX Controller process.

``` bash
/opt/nginx-controller/helper.sh controller start
/opt/nginx-controller/helper.sh controller stop
/opt/nginx-controller/helper.sh controller restart
/opt/nginx-controller/helper.sh controller status
```

&nbsp;

---

## Back Up and Restore Config and Encryption Keys



After installing NGINX Controller, you should back up the cluster config and encryption keys. You'll need these if you ever need to restore the NGINX config database on top of a new NGINX Controller installation.

- To back up the NGINX Controller cluster configuration and encryption keys:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config save
  ```

  The file is saved to `/opt/nginx-controller/cluster-config.tgz`.

- To restore the cluster's config and encryption keys, take the following steps:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config load <filename>
  ```



&nbsp;

---

## Restore Embedded Config Database



This section explains how to restore the embedded config database from the latest backup file or a specific, timestamped file.

{{< important >}}If you restore the config database on top of a new installation of NGINX Controller, make sure to follow the steps to [restore your NGINX config and encryption keys]({{< relref "/controller/admin-guides/backup-restore/backup-restore-cluster-config.md" >}}) afterward. {{< /important >}}

- To restore the embedded NGINX Controller config database **from the latest automated backup**, run the following command:

  ```bash
  /opt/nginx-controller/helper.sh backup restore
  ```

- To restore the embedded config database from **a specific backup file**:

  ```bash
  /opt/nginx-controller/helper.sh backup restore <filename>
  ```

  - If you installed the embedded config database on a **local volume**, the backup files are located in `/opt/nginx-controller/postgres_data/`.

  - If you installed the embedded config database on an **NFS volume**, follow the steps in [(NFS) Copy Config Database Backup to Local Volume for Restoration]({{< relref "/controller/admin-guides/backup-restore/backup-restore-embedded-config-db.md#nfs-copy-config-database-backup-to-local-volume-for-restoration" >}}) to download the backup file to your local volume, and then use the `helper.sh` script to restore from it.

&nbsp;



---

## Get NGINX Plus Repository Key and Certificate

To install NGINX Plus as a data plane for NGINX Controller, you need to have the NGINX repository key and certificate files.

{{< deprecated >}}Using the helper.sh script to download your NGINX Plus certificate and key bundle is deprecated in in NGINX Controller v3.9.{{< /deprecated >}}

{{< see-also >}}If you're running NGINX Controller v3.10+, you can use the REST API to [Download the NGINX Plus Cert and Key Bundle]({{< relref "/controller/admin-guides/install/get-n-plus-cert-and-key.md" >}}). {{< /see-also >}}&nbsp;

If you're running NGINX Controller 3.9 or earlier, use the `helper.sh` script to extract the NGINX repository key and certificate files:

```bash
/opt/nginx-controller/helper.sh repository-cred [-c|--cert <file name>] [-k|--key <file name>]
```

{{< important >}}

Make sure that you've [uploaded your license in NGINX Controller]({{< relref "licensing-controller.md" >}}) first before running the `helper.sh repository-cred` command to extract the repository files.

{{< /important >}}

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `-c` \| `--cert`  | Creates a certificate called `<file name>`. The default file name is `nginx-repo.crt` in the current directory.|
| `-k` \| `--key`  | Creates a key called `<file name>`. The default file name is `nginx-repo.key` in the current directory. |

&nbsp;

---

## Update SMTP Settings

Use the `helper.sh` script to change the SMTP address; port; TLS; sender; and optionally, the username and password.

``` bash
/opt/nginx-controller/helper.sh configsmtp <address> <port> <tls> <from> [auth] [username] [password]
```

For example:

``` bash
/opt/nginx-controller/helper.sh configsmtp 192.0.2.0 25 false noreply@example.com true user1 <password>
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `address`  | The host name or IP address of the SMTP server. |
| `port`     | The port of the SMTP server. |
| `tls`      | `true` or `false`. Set to `true` to require SSL for connections to the SMTP server. |
| `from`     | Sender's email address. |
| `auth`     | `true` or `false`. Set to `true` to authenticate when connecting to the SMTP server. |
| `username` | The username to use for access to the SMTP server. |
| `password` | The password to use for access to the SMTP server. |

&nbsp;

### Environment Variables

We strongly recommend that you use environment variables, especially for passwords, to prevent exposing sensitive information in system processes (for example, `ps`, `top`) and the bash history.

You use these SMTP environment variables with NGINX Controller:

| Environment Variables  | Description |
|----------|-------------|
| `CTR_SMTP_HOST` | The host name or IP address of the SMTP server. |
| `CTR_SMTP_PORT` | The port of the SMTP server.|
| `CTR_SMTP_TLS` |  `true` or `false`; Set to `true` to require SSL for connections to the SMTP server. |
| `CTR_SMTP_FROM` | Sender's email address. |
| `CTR_SMTP_AUTH` | `true` or `false`; Set to `true` to authenticate when connecting to the SMTP server. |
| `CTR_SMTP_USER` | The username to use for access to the SMTP server. |
| `CTR_SMTP_PASS` | The password to use for access to the SMTP server. |

For example:

``` bash
CTR_SMTP_HOST=192.0.2.0 \
CTR_SMTP_PORT=25 \
CTR_SMTP_TLS=false \
CTR_SMTP_FROM=noreply@nginx.test \
CTR_SMTP_AUTH=true CTR_SMTP_USER=user1 CTR_SMTP_PASS=<password> \
/opt/nginx-controller/helper.sh configsmtp
```

&nbsp;

---

## Update Database Settings

Use the `helper.sh` script to change the external config database address; port; and optionally, the username, password, and certificate authentication. However, if your current installation uses an internal config database, then these settings are read-only and cannot be modified using the `helper.sh` script (password and certificates will be automatically rotated with each Controller update).

``` bash
/opt/nginx-controller/helper.sh configdb <address> <port> [username] [password] [ssl] [ca] [cert] [key]
```

For example:

``` bash
/opt/nginx-controller/helper.sh configdb 192.0.2.1 5432 user1 <password> false
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `address`  | The host name or IP address of config database. |
| `port`     | The port of the database. |
| `username` | The username to use for access to the config database. |
| `password` | The password to use for access to the config database. |
| `ssl` | `true` or `false`. Set to 'true' to require SSL for connections to the config database. |
| `ca` | CA certificate file path. |
| `cert` | Certificate file path. |
| `key` | Key file path. |

&nbsp;

### Environment Variables

We strongly recommend that you use environment variables, especially for passwords, to prevent exposing sensitive information in system processes (for example, `ps`, `top`) and the bash history.

You can use these database environment variables with NGINX Controller:

| Environment Variables  | Description |
|----------|-------------|
| `CTR_DB_HOST` | The host name or IP address of the config database. |
| `CTR_DB_PORT` | The port of the config database used for incoming connections. |
| `CTR_DB_USER` | The username for the account to use for access to the config database; must be provided with password. |
| `CTR_DB_PASS` | The password for the account to use for access to the config database; must be provided with username. |
| `CTR_DB_ENABLE_SSL` | `true` or `false`; Set to `true` to require SSL for connections to the config database. |
| `CTR_DB_CA` | CA certificate file path. |
| `CTR_DB_CLIENT_CERT` | Certificate file path. |
| `CTR_DB_CLIENT_KEY` | Key file path. |

For example:

```bash
CTR_DB_HOST=192.0.2.1 \
CTR_DB_PORT=5432 \
CTR_DB_USER=user1 \
CTR_DB_PASS=<password> \
CTR_DB_ENABLE_SSL=false \
/opt/nginx-controller/helper.sh configdb
```

&nbsp;

---

## Update or Replace TLS Certificates

Use the `helper.sh` script to update or replace the TLS certificates that are used to connect to NGINX Controller.

``` bash
/opt/nginx-controller/helper.sh configtls <cert_file> <key_file>
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `cert_file` | Certificate file path. |
| `key_file` | Key file path. |

&nbsp;

---

## Print NGINX Controller Logs

To print the NGINX Controller logs, enter the following command:

``` bash
/opt/nginx-controller/helper.sh logs
```

&nbsp;

---

## Add a Custom Logo

The NGINX Controller logo in the user interface is replaceable with a custom logo. The requirements being:

- The logo file is in SVG format.
- The logo is square in shape.

{{< note >}} The above steps modify the logo in the top left corner and in the menu, not the favicon. {{< /note >}}

Follow the steps below to replace the logo:

1. Connect to the NGINX Controller host using 'ssh'.
1. Transfer the logo file to NGINX Controller using one of the following methods:
    1. Method 1: Download the file using curl after connecting to the host using the command `curl https://example.com/custom-logo.svg`.
    1. Method 2: Upload the logo to the host using SCP: `scp /local/path/custom-logo.svg user@controller-host:/remote/path`.
    1. Method 3: Copy/Paste the logo file.
        1. Copy the logo file to the clipboard before connecting to the host.
        1. After connecting to the host, paste the file.
1. Run `helper.sh setlogo <filename>` (<filename> is the name of the SVG file).
1. Wait for approximately five minutes for the cache to clear and the logo to appear in the user interface.
1. Re-run the `setlogo` command on each NGINX Controller node. This has to be done after an upgrade or reinstallation.

&nbsp;

---

## Create a Support Package

You can create a support package for NGINX Controller that you can use to diagnose issues.

{{< note >}}
You will need to provide a support package if you open a ticket with NGINX Support via the [MyF5 Customer Portal](https://account.f5.com/myf5).
{{< /note >}}&nbsp;

```bash
/opt/nginx-controller/helper.sh supportpkg [-o|--output <file name>] [-s|--skip-db-dump] [-t|--timeseries-dump <hours>]
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `-o` \| `--output`  | Save the support package file to `<file name>`. |
| `-s` \| `--skip-db-dump` | Don't include the database dump in the support package. |
| `-t` \| `--timeseries-dump <hours>` | Include the last `<n hours>` of timeseries data in the support package (default 12 hours). |

Take the following steps to create a support package:

1. Open a secure shell (SSH) connection to the NGINX Controller host and log in as an administrator.

1. Run the `helper.sh` utility with the `supportpkg` option:

    ```bash
    /opt/nginx-controller/helper.sh supportpkg
    ```

    The support package is saved to:

    `/var/tmp/supportpkg-<timestamp>.tar.gz`

    For example:

    `/var/tmp/supportpkg-20200127T063000PST.tar.gz`

1. Run the following command on the machine where you want to download the support package to:

    ``` bash
    scp <username>@<controller-host-ip>:/var/tmp/supportpkg-<timestamp>.tar.gz /local/path
    ```

### Support Package Details

{{< include "controller/helper-script-support-package-details.md" >}}



&nbsp;

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
