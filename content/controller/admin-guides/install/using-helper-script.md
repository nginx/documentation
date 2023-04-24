---
aliases:
- /platform/using-helper-script/
authors: []
categories:
- installation
- platform management
date: "2020-10-26T15:32:41-06:00"
description: Learn how to update NGINX Controller installation settings and manage
  the NGINX Controller service using the helper.sh script.
docs: DOCS-261
doctypes:
- task
draft: false
journeys:
- using
- self service
personas:
- devops
- netops
- secops
roles:
- admin
tags:
- docs
title: Update NGINX Controller Settings with helper.sh
toc: true
weight: 200
---

## Overview

You can use the NGINX Controller `helper.sh` script to update NGINX Controller installation settings and manage the NGINX Controller process. This tutorial shows you how to use `helper.sh` to perform the following tasks:

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



{{< include "controller/installer/helper-script/prereqs.md" >}}



&nbsp;

---

## View the Installed NGINX Version



{{< include "installer/helper-script/get-version.md" >}}



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

{{< important >}}If you restore the config database on top of a new installation of NGINX Controller, make sure to follow the steps to [restore your NGINX config and encryption keys]({{< relref "admin-guides/backup-restore/backup-restore-cluster-config.md" >}}) afterward. {{< /important >}}

- To restore the embedded NGINX Controller config database **from the latest automated backup**, run the following command:

  ```bash
  /opt/nginx-controller/helper.sh backup restore
  ```

- To restore the embedded config database from **a specific backup file**:

  ```bash
  /opt/nginx-controller/helper.sh backup restore <filename>
  ```

  - If you installed the embedded config database on a **local volume**, the backup files are located in `/opt/nginx-controller/postgres_data/`.

  - If you installed the embedded config database on an **NFS volume**, follow the steps in [(NFS) Copy Config Database Backup to Local Volume for Restoration]({{< relref "admin-guides/backup-restore/backup-restore-embedded-config-db.md#nfs-copy-config-database-backup-to-local-volume-for-restoration" >}}) to download the backup file to your local volume, and then use the `helper.sh` script to restore from it.

&nbsp;



---

## Get NGINX Plus Repository Key and Certificate



{{< include "installer/helper-script/get-repo-cert-and-key-deprecated.md" >}}



&nbsp;

---

## Update SMTP Settings



{{< include "installer/helper-script/update-smtp-settings.md" >}}



&nbsp;

---

## Update Database Settings



{{< include "installer/helper-script/update-db-settings.md" >}}



&nbsp;

---

## Update or Replace TLS Certificates



{{< include "installer/helper-script/config-tls.md" >}}



&nbsp;

---

## Print NGINX Controller Logs



{{< include "installer/helper-script/logs.md" >}}



&nbsp;

---

## Add a Custom Logo



{{< include "installer/helper-script/custom-branding.md" >}}



&nbsp;

---

## Create a Support Package



{{< include "installer/helper-script/create-support-package.md" >}}

### Support Package Details

{{< include "installer/helper-script/support-package-details.md" >}}



&nbsp;

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}