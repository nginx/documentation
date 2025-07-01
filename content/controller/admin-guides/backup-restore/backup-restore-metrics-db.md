---
description: Learn how to back up and restore the F5 NGINX Controller analytics database.
nd-docs: DOCS-250
title: Back Up & Restore the Analytics Database
toc: true
weight: 100
type:
- how-to
---

## Overview

This guide explains how to back up and restore the F5 NGINX Controller analytics database. Backing up and restoring the analytics data lets you preserve the history of graphs. Backing up this information is optional.

## Back Up the Analytics Database

Make a backup copy of the metrics database following the steps for your volume type:

- **Local**: Make a back up copy of the metrics data that's located in `/opt/nginx-controller/clickhouse_data` by default, or on the volume that you specified when installing NGINX Controller.

- **NFS**: Make a backup copy of all of the data in the NFS path or make a copy of the ClickHouse binary data. Refer to the official ClickHouse documentation on [Data Backup](https://clickhouse.tech/docs/en/operations/backup/).

- **EBS**: For AWS, refer to the [Amazon EBS snapshots](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html) documentation to create a volume snapshot.

## Restore the Analytics Database

Restore the backup copy of the metrics database following the steps for your volume type:

- **Local**: Copy the data you backed up to `/opt/nginx-controller/clickhouse_data`.

- **NFS**: Copy the ClickHouse binary data in the NFS path. Refer to the official ClickHouse documentation on [Data Backup](https://clickhouse.tech/docs/en/operations/backup/).

- **EBS**: For AWS, refer to the [Amazon EBS snapshots](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html) documentation to restore a volume snapshot.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
