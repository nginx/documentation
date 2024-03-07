---
title: "Back up and recovery"
---


By default, the data for API Connectivity Manager isn't included in [backups for NGINX Management Suite]({{< relref "/nms/admin-guides/maintenance/backup-and-recovery.md">}}). 

To back up module data, follow these steps:

1. Open a secure shell (SSH) connection to the NGINX Management Suite host and log in.
1. Edit the `backup.sh` and `restore.sh` scripts and uncomment the commands in the relevant sections:

    In **backup.sh**, uncomment the following line:

    ```shell
    ## Back up API Connectivity Manager
    # Uncomment the following line to back up API Connectivity Manager.
    ./backup-acm.sh
    ```

    Uncomment the following section as well:

    ```shell
	## Back up API Connectivity Manager
	# Uncomment the following line to back up API Connectivity Manager.
	ACM_ACTIVE=$(systemctl is-active --quiet nms-acm)
	IS_ACM_ACTIVE=$?
	if [ $IS_ACM_ACTIVE -ne 0 ]; then
	    echo "You need to start the required NGINX Management Suite services before running the backup script."
	    echo "Please ensure the following nms service is running:"
	    echo "nms-acm"
	    exit 1
	fi
    ```

    In **restore.sh**, uncomment the following line:

    ```shell
    ## Restore the API Connectivity Manager database.
    # Uncomment the following line to restore API Connectivity Manager.
    ./restore-acm.sh
    ```

    <br>

1. To create a backup, run the back up script:

    ```shell
    sudo ./backup.sh
    ```

1. To restore from a backup:

    Make sure the NGINX Management Suite service is stopped, then remove the existing database files.

    ```shell
    sudo systemctl stop nms
    sudo rm -rf /var/lib/nms/dqlite/*
    ```
    
    Run the restore script:

    ```shell
    sudo ./restore.sh /tmp/nms-backup-<DATETIME>.tgz
    ```