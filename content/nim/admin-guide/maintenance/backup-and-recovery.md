---
nd-docs: DOCS-1098
title: Back up and restore
toc: true
weight: 1
---

## Overview

NGINX Instance Manager includes several scripts for backing up and restoring configuration files, secrets, and databases used by the platform.

The backup and restore scripts are provided for reference and may need to be adjusted to suit your specific deployment.

{{< call-out "important" "NGINX Instance Manager 2.14.1 and earlier:" >}}If you're using **NGINX Instance Manager version 2.14.1 or earlier**, you'll need to [install SQLite]({{< ref "/nim/admin-guide/maintenance/sqlite-installation.md" >}}) to run the backup and recovery scripts.{{</call-out>}}

{{<call-out "note" "About nms in commands">}} Some commands and directories still use `nms` in their paths or names because they were established when NGINX Instance Manager was part of the NGINX Management Suite. These names remain unchanged in this version for consistency with the existing file structure.{{</call-out>}}

---

## NGINX Instance Manager deployed on a Virtual Machine or Bare Metal

### Before you begin

To follow the instructions in this guide, make sure you have the following:

- An installed version of NGINX Instance Manager
- NGINX Instance Manager services must be running:

    ```shell
    sudo systemctl start nms
    ```

### Make scripts executable

To run the backup and restore scripts, you need to set their permissions to make them executable.

1. Open a secure shell (SSH) connection to the NGINX Instance Manager host and log in.
2. Navigate to the directory where the scripts are located:

    ```shell
    cd /etc/nms/scripts
    ```

3. Run the following commands to make the scripts executable:

    ```shell
    sudo chmod +x backup.sh
    sudo chmod +x restore.sh
    sudo chmod +x support-package.sh
    ```

### Back up and restore NGINX Instance Manager

To back up configuration files, secrets, and databases:

1. Open a secure shell (SSH) connection to the NGINX Instance Manager host and log in.
2. Run the following commands to back up NGINX Instance Manager:

    ```shell
    cd /etc/nms/scripts
    sudo ./backup.sh
    ```

    The backup will be saved as a tarball, similar to this example: `/tmp/nms-backup-<DATETIME>.tgz`.

To restore NGINX Instance Manager:

1. Open a secure shell (SSH) connection to the NGINX Instance Manager host and log in.
2. Run the following commands to restore NGINX Instance Manager:

    ```shell
    cd /etc/nms/scripts
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```

---

## NGINX Instance Manager deployed in a Kubernetes Cluster

### Before you begin

To complete the steps in this guide, ensure the following:

- An installed version of NGINX Instance Manager

<a name="root-access"></a>

- **Root Access**:
  You’ll need superuser (sudo) access to run the backup and restore scripts, which use the `kubectl` command to interact with the Kubernetes API. Ensure that the root user has access to the Kubernetes cluster.

  To verify root access to the Kubernetes API, run this command:

    ```shell
    sudo kubectl -n nms get pods
    ```

  If there are no errors and you see a list of running pods/nodes, root access is confirmed.

  If the root user lacks access, configure the Kubernetes API access for root or provide the Kubernetes configuration file path through the `KUBECONFIG` environment variable:

    ```shell
    KUBECONFIG=/etc/kubernetes/admin.conf
    ```

  Replace `/etc/kubernetes/admin.conf` with the actual configuration path for your cluster if it differs.

- **Utility Pod**:
  Ensure the `utility` pod is installed in your Kubernetes cluster:

  1. Update your [Helm Deployment values.yaml file]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}), adding the following line to enable the utility pod:

    ```yaml
    global:
        utility: true
    ```

  2. [Upgrade your NGINX Instance Manager deployment]({{< ref "/nim/deploy/kubernetes/deploy-using-helm#helm-upgrade-nim" >}}).

  3. Download the Helm chart for the installed version of NGINX Instance Manager:

    ```shell
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update
    helm pull nginx-stable/nms
    tar zxvf nms-<version>.tgz
    ```

### Back up NGINX Instance Manager

To back up NGINX Instance Manager deployed in a Kubernetes cluster:

1. Copy the backup script `k8s-backup.sh` from the extracted Helm chart to your working directory:

    ```shell
    cp nms-<version>/charts/nms-hybrid/backup-restore/k8s-backup.sh .
    ```

2. Make the script executable:

    ```shell
    chmod +x k8s-backup.sh
    ```

3. Run the backup script:

    ```shell
    ./k8s-backup.sh
    ```

    {{< note >}}The backup script does not require `sudo` permissions or the `utility` pod.{{</note>}}

4. The script will prompt you for the NGINX Instance Manager namespace. It will create a backup archive called `k8s-backup-<timestamp>.tar.gz`.

### Full restoration to the same Kubernetes Cluster

To restore NGINX Instance Manager to the same Kubernetes cluster:

1. Copy the restore script `k8s-restore.sh` from the extracted Helm chart to your working directory:

    ```shell
    cp nms-<version>/charts/nms-hybrid/backup-restore/k8s-restore.sh .
    ```

2. Make the script executable:

    ```shell
    chmod +x k8s-restore.sh
    ```

3. Copy your backup file (`k8s-backup-<timestamp>.tar.gz`) to the same directory as `k8s-restore.sh`.

4. Run the restore script:

    ```shell
    sudo KUBECONFIG=/etc/kubernetes/admin.conf ./k8s-restore.sh -i k8s-backup-<timestamp>.tar.gz -r
    ```

    If the Kubernetes configuration is different, update the path accordingly.

    {{< note >}}The restore script requires [root access]({{< ref "/nim/admin-guide/maintenance/backup-and-recovery.md#root-access" >}}).{{</note>}}

5. After specifying the NGINX Instance Manager namespace, the script will use the provided backup archive.

    {{< note >}}The script uses the `utility` pod to restore databases and core secrets. It stops service pods during the restoration and restarts them afterward.{{</note>}}

### Data-only restoration to a different Kubernetes Cluster

To restore NGINX Instance Manager to a different Kubernetes cluster:

1. Copy the restore script `k8s-restore.sh` from the extracted Helm chart to your working directory:

    ```shell
    cp nms-<version>/charts/nms-hybrid/backup-restore/k8s-restore.sh .
    ```

2. Make the script executable:

    ```shell
    chmod +x k8s-restore.sh
    ```

3. Copy your backup file (`k8s-backup-<timestamp>.tar.gz`) to the same directory as `k8s-restore.sh`.

4. Run the restore script:

    ```shell
    sudo KUBECONFIG=/etc/kubernetes/admin.conf ./k8s-restore.sh -i k8s-backup-<timestamp>.tar.gz -r -d
    ```

    If the Kubernetes configuration differs, update the path accordingly.

    {{< note >}}The restore script requires [root access]({{< ref "/nim/admin-guide/maintenance/backup-and-recovery.md#root-access" >}}).{{</note>}}

5. After specifying the NGINX Instance Manager namespace, the script will restore the databases and core secrets.

If you want to restore user passwords, extract the backup archive and run the following commands:

  ```shell
  cd k8s-backup-<version>/secrets
  kubectl -n nms apply -f nms-auth.json
  kubectl -n nms delete pod apigw-<hash>
  ```

---

## ClickHouse

ClickHouse supports backup and restore on versions greater than v22.

Refer to [ClickHouse's documentation](https://clickhouse.com/docs/en/operations/backup) for backup and restore instructions.

To check your ClickHouse version, run:

```shell
clickhouse-server --version
```
