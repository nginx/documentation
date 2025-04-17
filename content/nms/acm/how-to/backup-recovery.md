---
title: "Back up and recovery"
toc: true
docs: "DOCS-1668"
---

## Overview

F5 NGINX Management Suite includes several scripts for backing up and restoring the configuration files, secrets, and databases used by the platform.

{{<important>}}The backup and recovery scripts are provided for reference and may need to be changed for your deployment.{{</important>}}

---

## NGINX Management Suite and API Connectivity Manager deployed in a Virtual Machine or Bare Metal

### Before you begin

To complete the instructions in this guide, you need the following:

- An installed version of Instance Manager
- An installed version of API Connectivity Manager
- Instance Manager versions older than 2.15.0 will require an installed version of SQLite. Refer to the [Install SQLite]({{< ref "/nim/admin-guide/maintenance/sqlite-installation.md" >}}) guide for installation instructions.
- The NGINX Management Suite services must be running:

    ```shell
    sudo systemctl start nms
    ```

### Make scripts executable

To run the backup and restore scripts, you need to set their permissions to make them executable.

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
1. Change to the directory where the scripts are located:

    ```shell
    cd /etc/nms/scripts
    ```

1. Run the following commands to make the scripts executable:

    ```shell
    sudo chmod +x backup.sh
    sudo chmod +x restore.sh
    sudo chmod +x backup-acm.sh
    sudo chmod +x restore-acm.sh
    sudo chmod +x support-package.sh
    ```

### Include module data

By default, the data for API Connectivity Manager isn't included in the backup.

To back up module data, follow these steps:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
1. Change to the directory where the scripts are located:

    ```shell
    cd /etc/nms/scripts
    ```
1. Edit the `backup.sh` and `restore.sh` scripts and uncomment the commands in the relevant sections:

    In **backup.sh**, uncomment the following lines:

    ```shell
	## Back up API Connectivity Manager
	# Uncomment the following line to back up API Connectivity Manager.
	ACM_ACTIVE=$(systemctl is-active --quiet nms-acm)
	IS_ACM_ACTIVE=$?
	if [ $IS_ACM_ACTIVE -ne 0 ]; then
	    echo "You need to start the required NGINX Management Suite
        services before running the backup script."
	    echo "Please ensure the following nms service is running:"
	    echo "nms-acm"
	    exit 1
	fi
    ```

    ```shell
    ## Back up API Connectivity Manager
    # Uncomment the following line to back up API Connectivity Manager.
    ./backup-acm.sh
    ```

    In **restore.sh**, uncomment the following lines:

    ```shell
	## Back up API Connectivity Manager
    # Uncomment the following line to back up API Connectivity Manager.
    ACM_ACTIVE=$(systemctl is-active --quiet nms-acm)
    IS_ACM_ACTIVE=$?
    if [ $IS_ACM_ACTIVE -eq 0 ]; then
        echo "You need to stop the required NGINX Management Suite
        services before running the restore script."
        echo "Please ensure the following nms service is stopped:"
        echo "nms-acm"
        exit 1
    fi
    ```

   ```shell
    ## Restore the API Connectivity Manager database.
    # Uncomment the following line to restore API Connectivity Manager.
    ./restore-acm.sh
    ```

### Back up and restore NGINX Management Suite and API Connectivity Manager

To back up the NGINX Management Suite configuration files, secrets, and databases:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
1. To back up NGINX Management Suite, run the following commands:

    ```shell
    cd /etc/nms/scripts
    sudo ./backup.sh
    ```

    The backup is saved to a tarball file similar to the following example: `/tmp/nms-backup-<DATETIME>.tgz`

To restore NGINX Management Suite:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
1. To restore NGINX Management Suite, run the following commands:

    ```shell
    cd /etc/nms/scripts
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```
---

## NGINX Management Suite and API Connectivity Manager deployed in a Kubernetes Cluster

### Before you begin

To complete the instructions in this guide, you need the following:

- An installed version of NGINX Management Suite and Instance Manager
- An installed version of API Connectivity Manager
- Instance Manager versions older than 2.15.0 will require an installed version of SQLite. Refer to the [Install SQLite]({{< ref "/nim/admin-guide/maintenance/sqlite-installation.md" >}}) guide for installation instructions.


<a name="root-access"></a>

- Root Access

    To back up and restore the NGINX Management Suite on Kubernetes, run the scripts as a superuser with `sudo`. These scripts use the `kubectl` command to interact with the Kubernetes API. It is necessary to ensure the target Kubernetes cluster is accessible to the root user.

    To confirm that the root user has access to the Kubernetes API, run the following command:

    ```shell
    sudo kubectl -n nms get pods
    ```

    If the result is error-free and the output is the list of currently running pods/nodes the root user has the required access.

    If the root user does not have the required access, you will need to configure the root user to have Kubernetes API access, or provide the script with the location of the Kubernetes configuration via the environment variable `KUBECONFIG`. For example:

   ```shell
    KUBECONFIG=/etc/kubernetes/admin.conf
    ```

    In the example above, `/etc/kubernetes/admin.conf` is the default configuration location of a Kubernetes cluster. If the configuration location is different for the target Kubernetes cluster, update the location accordingly.

- Utility pod

    To back up and restore NGINX Management Suite in a Kubernetes cluster, you need to install the `utility` pod in your Kubernetes cluster. For each module you want to back up and restore, you need to configure the `utility` pod accordingly:

    1. Update your [Helm Deployment values.yaml file]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}), add the `utility: true` line under `global` to enable the utility pod, and the required sections under `nmsModules` to  back up and restore API Connectivity Manager. Example below:

        ```yaml
        global:
            utility: true
            nmsModules :
                nms—acm:
                    enabled: true
                    addClaimsToUtility: true
        ```

    1. [Upgrade your NGINX Management Suite deployment]({{< ref "/nim/deploy/kubernetes/deploy-using-helm#helm-upgrade-nim" >}}) to apply the changes.

    1. Download the NGINX Management Suite Helm chart for your currently installed version of NGINX Management Suite:

        ```shell
        helm repo add nginx-stable https://helm.nginx.com/stable
        helm repo update
        helm pull nginx-stable/nms
        tar zxvf nms-<version>.tgz
        ```

### Back up NGINX Management Suite and API Connectivity Manager

To back up NGINX Management Suite deployed in a Kubernetes cluster, follow these steps:

1. Copy the backup script `k8s-backup.sh` extracted from `nms-<version>.tgz` to your working directory:

    ```shell
    cp nms-<version>/charts/nms-hybrid/backup-restore/k8s-backup.sh .
    ```

1. Make the scripts executable:

    ```shell
    chmod +x k8s-backup.sh
    ```

1. Run the backup script:

    ```shell
    ./k8s-backup.sh
    ```

    {{< note >}}The backup script does not need the `utility` pod or `sudo` permissions to create a backup.{{< /note >}}

1. The command will ask for the NGINX Management Suite namespace. The script will create a backup archive in the same directory called `k8s-backup-<timestamp>.tar.gz`.

### Full restoration to the same Kubernetes Cluster

To restore NGINX Management Suite and the installed modules deployed in the same Kubernetes cluster, follow these steps:

1. Copy the restore script `k8s-restore.sh` extracted from `nms-<version>.tgz` to your working directory:

    - For NGINX Management Suite and API Connectivity Manager, copy `k8s-restore.sh` from the `nms-<version>/charts/nms-hybrid/backup-restore/` directory.

    ```shell
    cp nms-<version>/nms/charts/nms-hybrid/backup-restore/k8s-restore.sh .
    ```

1. Make the scripts executable:

    ```shell
    chmod +x k8s-restore.sh
    ```

1. Copy your `k8s-backup-<timestamp>.tar.gz` file to the same directory as the `k8s-restore.sh` script.

1. Run the restore script:

    ```shell
    sudo KUBECONFIG=/etc/kubernetes/admin.conf ./k8s-restore.sh -i k8s-backup-<timestamp>.tar.gz -r
    ```

    In the command above, `/etc/kubernetes/admin.conf` is the default configuration location of a Kubernetes cluster. If the configuration location is different for the target Kubernetes cluster, update the command accordingly.


    {{< note >}}The restore script [needs root access]({{< ref "/nms/acm/how-to/backup-recovery.md#root-access" >}}) to Kubernetes for the restore operation.{{< /note >}}

1. The script will ask for the NGINX Management Suite namespace. Once the namespace has been provided, the script will use the specified backup archive.

    {{< note >}}The script will use the `utility` pod to access all the mounted volumes to restore database directories and core secrets; and `kubectl` to restore the Kubernetes configmaps and secrets. Before starting the restoration, the script will stop all service pods and start the `utility` pod. After finishing the restore, it will stop the `utility` pod and start all service pods.{{< /note >}}


### Data-only restoration to a different Kubernetes Cluster

To restore NGINX Management Suite and the installed modules into a different Kubernetes cluster, follow these steps:

1. Copy the restore script `k8s-restore.sh` extracted from `nms-<version>.tgz` to your working directory:

    - For NGINX Management Suite and API Connectivity Manager, copy `k8s-restore.sh` from the `nms-<version>/charts/nms-hybrid/backup-restore/` directory.

    ```shell
    cp nms-<version>/nms/charts/nms-hybrid/backup-restore/k8s-restore.sh .
    ```

1. Make the scripts executable:

    ```shell
    chmod +x k8s-restore.sh
    ```

1. Copy your `k8s-backup-<timestamp>.tar.gz` file to the same directory as the `k8s-restore.sh` script.

1. Run the restore script:

    ```shell
    sudo KUBECONFIG=/etc/kubernetes/admin.conf ./k8s-restore.sh -i k8s-backup-<timestamp>.tar.gz -r -d
    ```

    In the command above, `/etc/kubernetes/admin.conf` is the default configuration location of a Kubernetes cluster. If the configuration location is different for the target Kubernetes cluster, update the command accordingly.


    {{< note >}}The restore script [needs root access]({{< ref "/nms/acm/how-to/backup-recovery.md#root-access" >}}) to Kubernetes for the restore operation.{{< /note >}}

1. The script will ask for the NGINX Management Suite namespace. Once the namespace has been provided, the script will use the specified backup archive.

The restore script will only restore the databases and core secrets. If you want to restore the user passwords too, run the following commands on the extracted `k8s-backup-<timestamp>.tar.gz` file:

  ```shell
  cd k8s-backup-<version>/secrets
  kubectl -n nms apply -f nms-auth.json
  kubectl -n nms delete pod apigw-<hash>
  ```

---

## ClickHouse

ClickHouse supports backup and restore on versions greater than v22.

For instructions on how to back up and restore the ClickHouse database, please refer to [ClickHouse's documentation](https://clickhouse.com/docs/en/operations/backup).

To check your ClickHouse version, run the following command:

```shell
clickhouse-server --version
```
