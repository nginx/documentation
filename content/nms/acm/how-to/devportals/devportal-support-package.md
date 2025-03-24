---
description: This guide explains how to generate a support package for troubleshooting
  error scenarios.
docs: DOCS-1259
title: Create an NGINX Developer Portal Support Package
toc: true
weight: 300
type:
- reference
- how-to
---

{{< shortversions "1.0.0" "latest" "acmvers" >}}
## Overview

The support package script can be used to collect information about your system for troubleshooting and debugging issues.

The script collects system and service information and then packages the data into a tar archive, which you can share with [NGINX Customer Support]({{< relref "/nms/support/contact-support.md" >}}).

## Usage

The NGINX Developer Portal installer copies the `support-package.sh` script to the following location: `/etc/nginx-devportal/scripts/support-package.sh`.

To create a support package:

1. Run the support package script. The script requires root privileges to run.

    ``` bash
    sudo bash /etc/nginx-devportal/scripts/support-package.sh
    ```

    The support package is saved in the same location from where the script was run.

    (Optional) If you use a different NGINX Developer Portal config file than the default `/etc/nginx-devportal/devportal.conf` file, run the support package script with the `-c` flag and specify the path to your config file:

      ```bash
      sudo bash /etc/nginx-devportal/scripts/support-package.sh -c /your/config.conf
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

| Short | Long                      | Description                                                         | Example                                  | Default                               |
| ----- | ------------------------- | ------------------------------------------------------------------- | ---------------------------------------- | ------------------------------------- |
| `-h`  | `--help`                  | Prints information about the script arguments to stdout.            | `--help`                                 | N/A                                   |
| `-o`  | `--output_dir`            | The output directory where the tar archive is saved.                | `-o ~/output`                            | `$(pwd)`                              |
| `-c`  | `--devportal_config_path` | The path to the NGINX Developer Portal config file.                 | `-c /etc/nginx-devportal/devportal.conf` | `/etc/nginx-devportal/devportal.conf` |
| `-m`  | `--devportal_log_path`    | The directory where the NGINX Developer Portal log file is located. | `-m /var/log/nginx-devportal.log`        | `/var/log/nginx-devportal.log`        |

{{</bootstrap-table>}}

## Package Contents

The support package includes several directories containing information about the system, service, and database state.

The information included is based on the F5 NGINX products installed and configured.

### devportal-logs

The logs of the NGINX Developer Portal process.

### service-information

Information about the NGINX Developer Portal service running on the host. For the `nginx-devportal` process, the script collects:

- `journalctl` (10000 most recent rows)
- `systemctl status`

### system-information

The status and state information of the host running NGINX Developer Portal, including the following:

- System metrics (memory usage, CPU usage, etc.)
- File permissions of the Developer Portal
- Firewall or SELinux state
- Network interfaces
- Network information (hostname, iptables)
- Environment variables
- Disk usage of select directories
- Operating system version
- Installed Developer Portal version

### database snapshot

The support package script uses the `-c` flag ( or `--devportal_config_path`) to get the NGINX Developer Portal configuration. If the configuration file is not specified, the script uses the default value `/etc/nginx-devportal/devportal.conf`.

As the NGINX Developer Portal supports both SQLite & PostreSQL database types, the support package script will determine the database settings from the `devportal.conf` configuration file.

{{< note >}}
The NGINX Developer Portal support package script will try to utilize the relevant data backup tool for the database type used.  For example, the `sqlite3` binary will be needed in your path to allow a SQLite data dump to occur.  Similarly for PostgreSQL the `pg_dump` tool will be required.  If the relevant data dump tool is not currently found in the systems `$PATH`, an error will be logged to the console.
{{< /note >}}
