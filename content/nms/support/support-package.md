---
description: This guide explains how to generate a support package for troubleshooting
  error scenarios.
docs: DOCS-818
title: Create a Support Package
toc: true
weight: 200
type:
- reference
- how-to
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}
## Overview

The support package script can be used to collect information about your system for troubleshooting and debugging issues.

The script collects system and service information and then packages the data into a tar archive, which you can share with [NGINX Customer Support]({{< relref "/nms/support/contact-support.md" >}}).

## Usage

The F5 NGINX Instance Manager installer copies the `support-package.sh` script to the following location: `/etc/nms/scripts/support-package.sh`.

To create a support package:

1. Run the support package script. The script requires root privileges to run.

    ``` bash
    sudo bash /etc/nms/scripts/support-package.sh
    ```

    The support package is saved in the same location from where the script was run (if no `-t` argument is passed).

    (Optional) If you use a different Instance Manager config file than the default `/etc/nms/nms.conf` file, run the support package script with the `-c` flag and specify the path to your config file:

      ```bash
      sudo bash /etc/nms/scripts/support-package.sh -c /your/config.conf
      ```

2. To extract the package, use the `tar` command:

    ```bash
    tar -xvf support-pkg-<timestamp>.tar.gz
    ```

{{< note >}}
The supported shell is `bash`.
{{< /note >}}

### Arguments

The following table lists the arguments you can use with the support package script.

{{<bootstrap-table "table table-striped table-bordered">}}

| Short | Long                   | Description                                                         | Example                | Default             |
| ----- | ---------------------- | ------------------------------------------------------------------- | ---------------------- | ------------------- |
| `-h`  | `--help`               | Prints information about the script arguments to stdout.            | `--help`               | N/A                 |
| `-o`  | `--output_dir`         | The output directory where the tar archive is saved.                | `-o ~/output`          | `$(pwd)`            |
| `-n`  | `--nginx_log_path`     | The directory where the NGINX log files are located.                | `-n /var/log/nginx`    | `/var/log/nginx`    |
| `-c`  | `--nms_config_path`    | The path to the Instance Manager config file.                       | `-c /etc/nms/nms.conf` | `/etc/nms/nms.conf` |
| `-m`  | `--manager_log_path`   | The directory where the Instance Manager log file is located.       | `-m /var/log/nms`      | `/var/log/nms`      |
| `-t`  | `--target_host`        | The Instance Manager address (host:port).                           | `-t 127.0.0.1:443`     | `127.0.0.1:443`     |
| `-xd` | `--exclude_databases`  | Excludes database data from the support package.                    | `--exclude_databases`  | N/A                 |
| `-xt`| `--exclude_timeseries` | Excludes timeseries data from the support package.                  | `--exclude_timeseries` | N/A                 |

{{</bootstrap-table>}}

## Package Contents

The support package includes several directories containing information about the system, service, and database state.

The information included is based on the NGINX products installed and configured.

### nginx-logs

The access and error logs of the instances that Instance Manager monitors.

The access logs display the HTTP traffic for Instance Manager that's routed by the NGINX instance. The error log contains NGINX errors that occurred during runtime.

### nms-logs

The logs of the Instance Manager processes.

You can pipe the logs to `grep` to view entries belonging to only one of the three `nms` processes. For example, to view `nms-core` logs, run the following command:

```bash
cat nms.log | grep 'COR'
```

The following table shows the `nms` processes and pattern to `grep` on:

{{<bootstrap-table "table table-striped table-bordered">}}

| Process name  | Pattern |
| ------------- | ------- |
| nms-core      | 'COR'   |
| nms-dpm       | 'DPM'   |
| nms-ingestion | 'ING'   |

{{</bootstrap-table>}}

### service-information

Information about the Instance Manager and NGINX services running on the host. For each `nms` process and the `nginx` instance, the script collects:

- `journalctl` (10000 most recent rows)
- `systemctl status`

### system-information

The status and state information of the host running Instance Manager, including the following:

- System metrics (memory usage, CPU usage, etc.)
- File permissions of the Instance Manager
- Firewall or SELinux state
- Network interfaces
- Network information (hostname, iptables)
- Environment variables
- Disk usage of select directories
- Operating system version
- Installed Instance Manager version
- Instance Manager license

### dqlite snapshot

The support package script uses the `-c` flag ( or `--nms_config_path`) to get the Instance Manager configuration. If the configuration file is not specified, the script uses the default value `/etc/nms/nms.conf`.

{{< note >}}
If the Instance Manager configuration file does not specify addresses for the `core` and `dpm` databases, the default values are assumed: `127.0.0.1:7891` and `127.0.0.1:7890`.
{{< /note >}}

The support package script uses a small Go executable file called `dqlite-backup` (located in `/etc/nms/scripts/`) to connect to the databases and generate data dumps.

The collected data is saved to the directories `dqlite/core`, `dqlite/dpm`.

### timeseries

This folder contains status information, dumps, and statistics for the `nms` ClickHouse database. In particular, for metrics and events.
