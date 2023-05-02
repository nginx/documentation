---
docs: "DOCS-1192" 
---

{{<note>}}NGINX Management Suite requires ClickHouse 22.3.15.33 or later.{{</note>}}

NGINX Management Suite uses [ClickHouse](https://clickhouse.com) to store metrics, events, and alerts, as well as configuration settings.

Select the tab for your Linux distribution, then follow the instructions to install ClickHouse.

{{<tabs name="clickhouse">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

To install and enable ClickHouse CentOS, RHEL, and RPM-Based distributions, take the following steps:

1. Set up the RPM repository:

    ``` bash
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
    ```

1. Install the ClickHouse server and client:

    ```bash
    sudo yum install -y clickhouse-server clickhouse-client
    ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> Copy and save the ClickHouse user password for future reference. You'll need this password to access the ClickHouse client.

1. Start the ClickHouse server:

    ```bash
    sudo systemctl enable clickhouse-server
    sudo systemctl start clickhouse-server
    sudo systemctl status clickhouse-server
    clickhouse-client # or "clickhouse-client --password" if you set up a password.
    ```

1. Verify ClickHouse is running:

    ```bash
    sudo service clickhouse-server status
    ```

1. Enable ClickHouse so that it starts automatically if the server is restarted:

    ```bash
    sudo systemctl enable clickhouse-server
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

To install and enable ClickHouse on Debian, Ubuntu, and Deb-Based distributions, take the following steps:

1. Set up the Debian repository:

    ```bash
    sudo apt-get install -y apt-transport-https ca-certificates dirmngr
    GNUPGHOME=$(mktemp -d)
    sudo GNUPGHOME="$GNUPGHOME" gpg --no-default-keyring --keyring /usr/share/keyrings/clickhouse-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8919F6BD2B48D754
    sudo rm -r "$GNUPGHOME"
    sudo chmod +r /usr/share/keyrings/clickhouse-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb lts main" | sudo tee \
        /etc/apt/sources.list.d/clickhouse.list
    sudo apt-get update
    ```

2. Install the ClickHouse server and client:

    ``` bash
    sudo apt-get install -y clickhouse-server clickhouse-client
    ```

    > <span style="color: #c20025;"><i class="fas fa-exclamation-triangle"></i> **IMPORTANT!**</span> Copy and save the ClickHouse user password for future reference. You'll need this password to access the ClickHouse client.

3. Start the ClickHouse server:

    ``` bash
    sudo service clickhouse-server start
    clickhouse-client # or "clickhouse-client --password" if you've set up a password.
    ```

4. Verify ClickHouse is running:

    ```bash
    sudo service clickhouse-server status
    ```

5. Enable ClickHouse so that it starts automatically if the server is restarted:

    ```bash
    sudo systemctl enable clickhouse-server
    ```

{{%/tab%}}

{{</tabs>}}

NGINX Management Suite uses the following default values for ClickHouse:

<details open>
<summary><i class="fa-solid fa-circle-info"></i> Default ClickHouse values</summary>

{{<important>}}You can customize these settings. However, if you use custom settings, make sure to follow the [Configure ClickHouse]({{< relref "admin-guides/getting-started/configure-clickhouse.md" >}}) instructions to update the `nms.conf` file after you've installed NMS; otherwise NMS won't be able to connect to ClickHouse.{{</important>}}

{{< include "nms/prepare-nms-platform/clickhouse-defaults.md" >}}

</details>
