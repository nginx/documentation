---
description: This page describes how to trigger the automatic collection of data required
  to troubleshoot issues in a NGINX or F5 NGINX Plus deployment.
docs: DOCS-1357
title: NGINX Diagnostic Package
toc: true
weight: 400
type:
- how-to
---

<span id="intro"></span>
## Overview

NGINX Diagnostic Package is used to obtain additional information needed by [F5 Technical Support](https://account.f5.com/myf5) when troubleshooting your issue.

The package is created by a script that can be [downloaded](https://nginx.org/download/nginx-supportpkg.sh) from the [nginx.org](https://nginx.org/download/) website.

The script collects the following information:

- host commands such as `ps`, `lsof`, `vmstat`
- NGINX configuration files
- NGINX log files
- NGINX service information
- NGINX process information
- NGINX versions, dynamically linked libraries
- NGINX Plus API endpoints
- NGINX Agent logs and configs if NGINX Agent is present
- NGINX App Protect logs and configs if F5 NGINX App Protect is present

The script does not collect or create:

- njs scripts
- Lua scripts
- Core dumps

{{< note >}}
It is highly recommended that you review the script and the created resources and verify that they conform with your organization's data sharing policies.
{{< /note >}}


<span id="oses"></span>
## Supported Operating Systems

The script can be run on most [operating systems supported by NGINX](https://docs.nginx.com/nginx/technical-specs/) and has been tested on the following operating systems:

- AlmaLinux 9.1
- Amazon Linux 2
- CentOS 7
- Debian 11
- RHEL 9.1
- Rocky Linux 9.1
- SUSE Linux Enterprise Server 15
- Ubuntu 20.04


<span id="usage"></span>
## Usage

To create NGINX Diagnostic Package:

1. [Download](https://nginx.org/download/nginx-supportpkg.sh) the `nginx-supportpkg.sh` script:

   ```shell
   wget https://nginx.org/download/nginx-supportpkg.sh
   ```

2. Grant execution permissions to the script:

   ```shell
   chmod +x nginx-supportpkg.sh
   ```

3. Run the script. The script requires root privileges to run. The script can be run with optional  arguments, see [Arguments](#arguments) for details.

   ```shell
   sudo ./nginx-supportpkg.sh
   ```

   The created package will be located in the same directory as the current script. It is a `.tar.gz` archive named according to the file name pattern: `support-pkg-<timestamp>.tar.gz`.

4. After the package has been created, it is recommended to extract and review its contents. Use the `tar` command to extract the archive:

   ```shell
   tar -xvf support-pkg-1682457903.tar.gz
   ```

   The archive contains textual output of all the commands run by the script to make it easier to review the collected data.


<span id="arguments"></span>
## Arguments

The following table lists the arguments you can use to customize the data that needs to be collected based on your NGINX deployment.

{{<bootstrap-table "table table-striped table-bordered">}}

| Short | Long                     | Description                                                           | Example                  | Default          |
| ----- | ------------------------ | ----------------------------------------------------------------------| -------------------------| -----------------|
| `-h`  | `--help`                 | Prints information about the script arguments to stdout.              | `--help`                 | N/A              |
| `-d`  | `--debug`                | Sets bash debug flag.                                                 | `--debug`                | N/A              |
| `-o`  | `--output_dir`           | The output directory where the tar archive is saved.                  | `-o ~/output`            | `$(pwd)`         |
| `-n`  | `--nginx_log_path`       | The directory where the NGINX log files are located.                  | `-n /var/log/nginx`      | `/var/log/nginx` |
| `-xc` | `--exclude_nginx_configs`| Excludes all NGINX configuration files from the support package.      | `--exclude_nginx_configs`| N/A              |
| `-xl` | `--exclude_nginx_logs`   | Excludes all NGINX log files from the support package.                | `--exclude_nginx_logs`   | N/A              |
| `-ac` | `--exclude_agent_configs`| Excludes all NGINX Agent configuration files from the support package.| `--exclude_agent_configs`|  N/A             |
| `-al` | `--exclude_agent_logs`   | Excludes all NGINX Agent logs from the support package.               | `--exclude_agent_logs`   | N/A              |
| `-nc` | `--exclude_nap_configs`  | Excludes all NGINX App Protect config files from the support package. | `--exclude_nap_configs`  | N/A              |
| `-nl` | `--exclude_nap_logs`     | Excludes all NGINX App Protect log files from the support package.    | `--exclude_nap_logs`     | N/A              |
| `-ea` | `--exclude_api_stats`    | Excludes NGINX Plus API stats from the support package.               | `--exclude_api_stats`    | N/A              |
| `-pi` | `--profile_interval`     | Profiling interval in seconds.                                        | `-pi 20`                 | 15               |

{{</bootstrap-table>}}

