---
description: This guide outlines the steps for creating a support package from a Helm
  installation to aid in troubleshooting error scenarios.
nd-docs: DOCS-1123
title: Create a Support Package from a Helm Installation
toc: true
weight: 200
type:
- reference
- how-to
---

{{< shortversions "2.5.0" "latest" "nimvers" >}}

## Overview

Use the Kubernetes support package script to collect information about your system for troubleshooting and debugging issues.

The script collects system and service information and then packages the data into a tar archive, which you can share with [NGINX Customer Support]({{< ref "/nms/support/contact-support.md" >}}).

---

## Before You Begin

To complete the steps in this guide, you need the following:

- `bash` 4.0 or higher

---

## Usage

The F5 NGINX Management Suite Helm chart includes the `k8s-support-package.sh` script in the following location:

- `/support-package/k8s-support-package.sh`.

To create a support package from a Helm installation:

1. Download the latest NGINX Management Suite Helm chart:

    ``` bash
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update
    helm pull nginx-stable/nms
    tar zxvf nms-<version>.tgz
    ```

2. Run the Kubernetes support package script. See the [Arguments](#arguments) section for a list of the available options.

    ``` bash
    bash ./nms/charts/nms-hybrid/support-package/k8s-support-package.sh
    ```

    The Kubernetes support package is saved in the same location from where you run the script.

3. To extract the package, use the `tar` command:

    ``` bash
    tar -xvf k8s-support-pkg-<timestamp>.tar.gz
    ```

---

## Arguments

The following table lists the arguments you can use with the Kubernetes support package script.

{{<bootstrap-table "table table-striped table-bordered">}}

| Short | Long                   | Description                                                | Example       | Default  |
|-------|------------------------|------------------------------------------------------------|---------------|----------|
| `-h`  | `--help`               | Prints information about the script arguments to `stdout`. | `--help`      | N/A      |
| `-o`  | `--ouput_dir`          | The output directory where the tar archive is saved.       | `-o ~/output` | `$(pwd)` |
| `-n`  | `--namespace`          | The namespace of the Helm installation.                    | `-n nms`      | `<none>` |
| `-xd` | `--exclude_databases`  | Exclude Dqlite database backup data.                       | `-xd`         | `False`  |
| `-xt` | `--exclude_timeseries` | Exclude ClickHouse time series data.                       | `-xt`         | `False`  |
| `-m`  | `--modules`            | Include specific modules in Dqlite database backup data.   | `-m acm`      | `False`  |

{{</bootstrap-table>}}

---

## Package Contents

The Kubernetes support package includes several directories containing information about the cluster, namespace, application, and database state.

### k8s-support-package.log

- A log of all output from the `k8s-support-package.sh` script.

### chart-files

- A snapshot of the Helm chart files in the parent directory (excluding the support-package directory you're running the script from).

### version-info

Includes the versions of:

- Helm chart
- `kubectl` tool
- `helm` tool
- NGINX gateway
- ClickHouse

### cluster-info

Includes information for:

- Cluster
- Node
- Storage Class

### namespace-info

Includes information for:

- General namespace data
- Events
- API version
- API services
- API resources

### app-info

Includes information about the NGINX Management Suite application:

- Deployments
- Services
- Persistent Volumes
- Persistent Volume Claims
- Secrets
- Configmaps
- Pods

### pod-logs

The logs of the NGINX Management Suite processes, NGINX gateway, and ClickHouse.

The files in the `pod-logs` directory are named using the format `pod_name-<timestamp>.logs`.

For example, the NGINX Management Suite `core` service logs are stored in the file `core-<id>-logs.txt`.

### pod-system-info

Includes information about the status and state of each pod:

- Operating system version
- Environment variables
- Processes running

### dqlite

The Kubernetes support package script uses a Go executable file named `dqlite-backup` (located in `/etc/nms/scripts/` inside applicable NGINX Management Suite containers) to connect to the databases and generate data dumps.

The collected data is saved to the following directories:

- `dqlite/core`
- `dqlite/dpm`
- `dqlite/integrations`

If you have specified a module using the `--modules` flag, the collected data is saved to the `dqlite/<moduleName>` directory.

### timeseries

This folder contains status information, dumps, and statistics for the `nms` ClickHouse database. In particular, for metrics and events.
