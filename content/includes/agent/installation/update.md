---
docs:
files:
   - content/agent/install-upgrade/update.md
   - content/nginx-one/agent/install-upgrade/update.md
---


{{< note >}} If you are using a version **older than NGINX Agent v2.31.0**, you must stop NGINX Agent before updating:

   - `sudo systemctl stop nginx-agent`

And start it again after the update:

   - `sudo systemctl start nginx-agent`
{{< /note >}}

Follow the steps below to update NGINX Agent to the latest version.
The same steps apply if you are **upgrading from NGINX Agent v2 to NGINX Agent v3**.

1. Open an SSH connection to the server where you've installed NGINX Agent.

1. Make a backup copy of the following locations to ensure that you can successfully recover if the upgrade does not complete
   successfully:

    - `/etc/nginx-agent`
    - Every configuration directory specfied in `/etc/nginx-agent/nginx-agent.conf` as a `config_dirs` value

1. Install the updated version of NGINX Agent:

    - CentOS, RHEL, RPM-Based

        ```shell
        sudo yum -y makecache
        sudo yum update -y nginx-agent
        ```

    - Debian, Ubuntu, Deb-Based

        ```shell
        sudo apt-get update
        sudo apt-get install -y --only-upgrade nginx-agent -o Dpkg::Options::="--force-confold"
        ```
