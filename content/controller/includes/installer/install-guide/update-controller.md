To update the NGINX Controller software, take the steps below. When complete, you must also update the Controller Agent software on each monitored NGINX Plus instance.

When updating NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

{{< warning >}} Do not update the nodes in a multi-node cluster in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

{{< caution >}}
We strongly recommend that you make a backup of the following information before proceeding, to avoid potential data and/or configuration loss:

- [Back up the NGINX Controller databases]({{< relref "admin-guides/backup-restore" >}}).
- Back up the NGINX Controller cluster configuration and encryption keys. These are required if you need to restore the config database on top of a new installation of NGINX Controller.

    ```bash
    /opt/nginx-controller/helper.sh cluster-config save
    ```

- Back up the Controller Agent `agent.conf` file by copying it from its current location to a new location. This file is present on each NGINX Plus instance.

    ```bash
    cp /etc/controller-agent/agent.conf <temporary location>
    ```

{{< /caution >}}

1. Download the installer package from the [MyF5 Customer Portal](https://my.f5.com/manage/s/downloads).

1. Extract the installer package files:

    ```bash
    tar xzf controller-installer-<version>.tar.gz
    ```

1. Before updating, check the NGINX Controller status to confirm the installation is healthy.

    ```bash
    ./helper.sh controller status
    ```

    Resolve any degradations before updating.

1. Run the update script:

    ```bash
    cd controller-installer
    ./update.sh
    ```

    {{< note >}}If you're upgrading from an older version of NGINX Controller and you installed Controller as root user, use `--allow-with-root` flag when running an update script. {{< /note >}}

1. If you are logged in to NGINX Controller using a web browser, sign out and log in again.

    - To sign out, select your username in the upper right-hand corner, and then select "Sign Out". For optimal performance, also flush your browser cache.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-293 -->