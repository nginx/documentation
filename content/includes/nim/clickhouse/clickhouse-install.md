---
docs:
files:
- content/nim/deploy/vm-bare-metal/install-nim-manual.md
---

NGINX Instance Manager uses [ClickHouse](https://clickhouse.com) to store metrics, events, alerts, and configuration settings.

If you install ClickHouse and choose to set a password (the default is an empty string), you must add it to the `clickhouse.password` setting in the `/etc/nms/nms.conf` file. If the password is missing or incorrect, NGINX Instance Manager **will not start**.

For instructions and additional configuration options, including TLS settings, see [Configure ClickHouse]({{< ref "nim/system-configuration/configure-clickhouse.md" >}}).

NGINX Instance Manager requires ClickHouse version {{< clickhouse-version >}} or later.


Follow these steps to install and enable ClickHouse on supported Linux distributions.

1. First, set up the repository.

   - For RPM-based systems (CentOS, RHEL):

      ```shell
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
      ```

   - For Debian-based systems (Debian, Ubuntu):

      ```shell
      sudo apt-get install -y apt-transport-https ca-certificates dirmngr
      GNUPGHOME=$(mktemp -d)
      sudo GNUPGHOME="$GNUPGHOME" gpg --no-default-keyring --keyring /usr/share/keyrings/clickhouse-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8919F6BD2B48D754
      sudo rm -r "$GNUPGHOME"
      sudo chmod +r /usr/share/keyrings/clickhouse-keyring.gpg

      echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb lts main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
      sudo apt-get update
      ```

2. Next, install the ClickHouse server and client:

   - For RPM-based systems (CentOS, RHEL):

      ```shell
      sudo yum install -y clickhouse-server clickhouse-client
      ```

   - For Debian-based systems (Debian, Ubuntu):

      ```shell
      sudo apt-get install -y clickhouse-server clickhouse-client
      ```

3. Then, enable the ClickHouse service so it starts automatically on reboot:

   ```shell
   sudo systemctl enable clickhouse-server
   ```

4. Start the ClickHouse service:

   ```shell
   sudo systemctl start clickhouse-server
   ```

5. Finally, confirm the service is running:

   ```shell
   sudo systemctl status clickhouse-server
   ```
