To restore the embedded config database from a specific backup file, the file needs to be on your local volume.

Take the following steps to copy an embedded config database backup file from an NFS volume to your local volume for restoration:

1. Log on to the node where PostgreSQL is installed as a user with sudo privileges.

1. Change to the `/opt/nginx-controller` directory:

    ``` bash
    cd /opt/nginx-controller
    ```

1. Create a local backup directory to copy the backup file to:

    ``` bash
    mkdir local_backups
    ```

1. Get the NFS volume details:

    ``` bash
    mount | grep nfs
    ```

    The output looks similar to the following:

    ``` bash
    <nfs_host>:<path_on_host> on <local path> type nfs4 (mount options...)
    ```

    For example:

    ``` bash
    192.0.2.1:/mnt/nfs_share/nfs_postgresql on /var/lib/kubelet/pods/1ce4e221-d6d6-434f-9e73-bc81c879530e/volumes/kubernetes.io~nfs/controller-postgres type nfs4 (mount options ...)
    ```

1. Record the `<nfs_host>:<path_on_host>` details corresponding to the `nfs_postgresql` volume, namely the volume mounted on the Kubernetes `controller-postgres` container.

    For example:

    ``` bash
    192.0.2.1:/mnt/nfs_share/nfs_postgresql
    ```

1. Create a parent directory to mount the NFS path to:

    ``` bash
    sudo mkdir -p /mnt/local_pgdata
    ```

1. Mount the NFS path:

    ``` bash
    sudo mount <nfs_host>:<path_on_host> /mnt/local_pgdata
    ```

    For example:

    ``` bash
    sudo mount 192.0.2.1:/mnt/nfs_share/nfs_postgresql /mnt/local_pgdata
    ```

1. View the list of the available backup files. The files have the following naming scheme: `backup_<timestamp>.tar`.

    ```bash
    ls /mnt/local_pgdata/
    ```

1. Copy the backup file from which you want to restore to the `local_backups/` directory:

    ``` bash
    sudo cp /mnt/local_pgdata/backup_<timestamp>.tar local_backups/
    ```

1. Use the NGINX Controller `helper.sh` script to restore the backup file:

    ``` bash
    /opt/nginx-controller/helper.sh backup restore local_backups/backup_<timestamp>.tar
    ```

1. After the backup has been restored, you can unmount the NFS path and delete the backup file in the `local_backups` directory:

    ``` bash
    sudo umount /mnt/local_pgdata
    rm -i local_backups/backup_<timestamp>.tar
    ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-263 -->